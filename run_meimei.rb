#!/usr/bin/env ruby

require 'rubygems'
require 'meimei'

client = Meimei::Client.new("meimei", :password => "mercury555lampe", :log_dir => "/home/albert/meimei/log")
client.add_server("irc.synirc.net", 6667, "#meimei,#marimite,#circlenine,#raspberryheaven")
#client.add_server("irc.synirc.net", 6667, "#meimei")
client.start()
