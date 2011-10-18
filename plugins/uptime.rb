require 'rubygems'
require 'net/ssh'

define_plugin("!uptime") do |msg|
  sonohara = `uptime`.strip
  hijiribe = nil
  dbserver = nil

  Net::SSH.start("hijiribe", "albert") do |ssh|
    hijiribe = ssh.exec!("uptime").strip
  end

  Net::SSH.start("dbserver", "albert") do |ssh|
    dbserver = ssh.exec!("uptime").strip
  end

  reply "sonohara: #{sonohara}"
  reply "hijiribe: #{hijiribe}"
  reply "dbserver: #{dbserver}"
end
