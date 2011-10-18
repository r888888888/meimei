#!/usr/bin/env ruby

require 'logger'
require 'socket'

module Meimei
  class Client
    # === Parameters
    # - nick: The nickname your bot will use.
    # - options[:username]: The username of your bot (defaults to nick).
    # - options[:realname]: The real name of your bot (defaults to nick).
    # - options[:password]: The password for your bot's account.
    # - options[:plugin_dir]: A path to the directory where Meimei plugins will be stored (defaults to plugins).
    # - options[:log_dir]: A path to where log files will be stored (defaults to .).
    # - options[:log_level]: The log level. Can be: :error, :info, :debug. Defaults to :info.
    def initialize(nick, options = {})
      @servers = []
      @running = false
      @command_plugins = []
      @timer_plugins = []
      @nick = nick
      @username = options[:username] || @nick
      @realname = options[:realname] || @nick
      @password = options[:password]
      @plugin_dir = options[:plugin_dir] || "plugins"
      @log_dir = options[:log_dir] || "."
      @log_level = options[:log_level] || :info
      @logger = Logger.new(open("#{@log_dir}/#{@nick}-#{Time.now.strftime('%Y%m%d-%H%M')}.log", "w"))
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @last_saw_traffic_at = Time.now
    end
    
    # Registers a server with the client. This method will not open a connection.
    def add_server(hostname, port, autojoin)
      @servers << Server.new(hostname, port, autojoin, :log_dir => @log_dir, :log_level => @log_level)
    end
    
    # Reloads all plugins.
    def load_plugins
      @command_plugins.clear()
      @timer_plugins.clear()

      # TODO: This is hackish
      Dir["#{@plugin_dir}/*.rb"].sort.each do |file|
        eval(File.open(file, "r").read, binding, file)
      end
    end
    
    # Autopings any server that hasn't seen traffic in over 5 minutes
    def autoping
      @servers.each do |server|
        if server.last_saw_traffic_at + 300 < Time.now
          server.write("PING #{server.hostname}")
          
          # Artificially set the last_saw_traffic_at value to now so that we don't flood the server
          server.last_saw_traffic_at = Time.now
        end
      end
    end
    
    # Creates a new plugin.
    #
    # === Parameters
    # - name: The name of the plugin. There are two special cases: (1) If the name begins with "!", then it is considered a command. For example, a plugin named "!wiki" would only be invoked if a message began with "!wiki". The message passed to the plugin will have the command stripped out. (2) If the plugin begins with "@", then it is considered a timer event. For example, a plugin named "@60" will run every 60 seconds. "@10m" will run every 10 minutes, and "@4h" will run every 4 hours.
    # - options[:position]: Insert plugin at position n (lower number positions will be run first).
    def define_plugin(name, options = {}, &block)
      # TODO: Is there a memory leak here?
      
      case name
      when /^@(\d+)([mh])?/
        interval = $1.to_i
                
        if $2 == "m"
          interval = interval * 60
        elsif $2 == "h"
          interval = interval * 60 * 60
        end
        
        plugins = @timer_plugins
        plugin = [name, interval, Time.now, block, options]
        
      else
        plugins = @command_plugins
        plugin = [name, block, options]
      end

      if options[:position]
        plugins.insert(options[:position], plugin)
      else
        plugins << plugin
      end
      
      plugins.compact!
    end
    
    # Run all timer plugins.
    def check_timer_plugins
      @timer_plugins.each do |plugin|
        begin
          # Need to refer directly to the array since we'll be changing its values
          # plugin[0]: name
          # plugin[1]: interval
          # plugin[2]: next_run_at
          # plugin[3]: block
          # plugin[4]: options
          
          if plugin[2] < Time.now
            plugin[3].call()
            plugin[2] = Time.now + plugin[1]
          end
        rescue Exception => e
          e.dump(@logger)
        end
      end
    end
    
    # Run all command plugins.
    def check_command_plugins(msg)
      @command_plugins.each do |name, block, options|
        begin
          if name =~ /^!/
            if msg =~ /^#{name}\b/
              msg = msg.gsub(/!\S+\s*/, "")
              block.call(msg)
            end
          else
            block.call(msg)
          end
        rescue Exception => e
          reply "Error: #{e.class}"
          e.dump(@current_server.logger)
        end
      end
    end

    # Returns the first server that has data to be read.
    def select
      sockets = @servers.map {|x| x.socket}.compact
      socket = Kernel.select(sockets, nil, nil, 1)
      
      if socket == nil
        return nil
      else
        socket = socket[0][0]
        return @servers.find {|x| x.socket.__id__ == socket.__id__}
      end
    end
    
    # Starts the main event loop.
    def start
      self.load_plugins()
      @running = true
      
      while @running
        @servers.each do |server|
          unless server.is_connected
            if server.reconnect_delay_passed? && server.connect
              server.write("PASS #{@password}") if @password
              server.write("NICK #{@nick}")
              server.write("USER #{@username} hostname servername :#{@username}")
              server.autojoin.each do |channel|
                server.write("JOIN #{channel}")
              end
            end
          end

          self.autoping()
          self.check_timer_plugins()
          
          @current_server = self.select()

          if @current_server
            msg = @current_server.read
            
            if msg != nil
              self.process_message(msg)
            end
          end
        end        
      end
    end
    
    # Quits all clients and ends the event loop.
    def quit(msg = nil)
      @servers.each do |server|
        if msg
          server.write("QUIT :#{msg}")
        else
          server.write("QUIT")
        end
      end
      
      @running = false
    end
    
    # Respond to the current server/channel/user. If {with_nick} is true, then the messager's sender's nick will be prepended to the response.
    def reply(msg, with_nick = true)
      if with_nick
        @current_server.write("PRIVMSG #{@current_to} :#{@current_from}: #{msg}")
      else
        @current_server.write("PRIVMSG #{@current_to} :#{msg}")
      end
    end
    
    # Send {msg} to {to} on {server}. {to} can either be a channel or someone's nick.
    def say(server, to, msg)
      if server.is_a?(String)
        server = @servers.find {|x| x.hostname == server}
      end
      
      server.write("PRIVMSG #{to} :#{msg}")
    end
    
    # Parses a messages and dispatches as necessary.
    def process_message(msg)
      @current_from = nil
      @current_to = nil
      @current_msg = nil
      
      case msg
      when /^:(.+?)!(.+?)@(\S+) PRIVMSG (\S+) :(.+)$/
        @current_from = $1
        @current_to = $4
        @current_msg = $5.strip

        self.check_command_plugins(@current_msg)
        
      when /^PING (.+)$/
        @current_server.write("PONG #{$1}")
      end
    end
  end
end
