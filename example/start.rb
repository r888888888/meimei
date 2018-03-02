#!/usr/bin/env ruby

require 'rubygems'
require 'meimei'

client = Meimei::Client.new("meimei", password: "password")
client.add_server("irc.net", 6660, "#meimei,#anotherchannel")
client.start
