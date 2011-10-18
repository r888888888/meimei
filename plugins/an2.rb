require 'cgi'

define_plugin("!an2") do |msg|
  reply "http://www.animenewsnetwork.com/encyclopedia/search/name?q=#{CGI.escape(msg)}"
end
