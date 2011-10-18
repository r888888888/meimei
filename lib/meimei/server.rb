module Meimei
  class Server
    attr_accessor :socket, :hostname, :port, :is_connected, :logger, :autojoin, :last_saw_traffic_at
    
    def initialize(hostname, port, autojoin, options = {})
      @hostname, @port, @is_connected = hostname, port, false
      @log_dir = options[:log_dir] || "."
      @logger = Logger.new(open("#{@log_dir}/#{@hostname}-#{Time.now.strftime('%Y%m%d-%H%M')}.log", "w"))
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @last_saw_traffic_at = Time.now
      
      case options[:log_level]
      when :fatal
        @logger.level = Logger::FATAL
        
      when :error
        @logger.level = Logger::ERROR
        
      when :warn
        @logger.level = Logger::WARN
        
      when :info
        @logger.level = Logger::INFO
        
      when :debug
        @logger.level = Logger::DEBUG
        
      else
        @logger.level = Logger::INFO
      end

      @autojoin = autojoin.split(/,\s*/)
    end

    def close
      begin
        @socket.close if @socket
      rescue Exception => x
        @is_connected = false
        @logger.info "* Could not close socket"
        x.dump(@logger)
      end
    end
    
    def reconnect_delay_passed?
      if @last_connected_at == nil
        @last_connected_at = Time.now
        return true
      end
      
      if Time.now - @last_connected_at > 10
        @last_connected_at = Time.now
        return true
      else
        return false
      end
    end
    
    def connect
      begin
        self.close()
        @socket = TCPSocket.open(@hostname, @port)
        @is_connected = true
        @logger.info "* Connected (resolved to #{@socket.peeraddr[3]})"
      rescue Exception => x
        @is_connected = false
        @logger.info "* Connection failed"
        x.dump(@logger)
      end
      
      return @is_connected
    end
    
    def read
      begin      
        msg = @socket.gets
        @last_saw_traffic_at = Time.now
        @logger.debug "> #{msg}"
        return msg
      rescue Errno::ECONNRESET => x
        @logger.info "* Connection reset"
        @is_connected = false
        x.dump(@logger)
        return nil
      rescue Exception => x
        @logger.info "* Read failed"
        @is_connected = false
        x.dump(@logger)
        return nil
      end
    end
    
    def write(msg)
      @logger.debug "< #{msg}"
            
      begin
        @socket.write(msg + "\n")
      rescue Errno::ECONNRESET => x
        @logger.info "* Connection reset"
        @is_connected = false
        x.dump(@logger)
      rescue Exception => x
        @logger.info "* Write failed"
        @is_connected = false
        x.dump(@logger)
      end
    end
  end
end
