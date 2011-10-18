require 'timeout'
require 'net/http'
require 'cgi'

define_plugin("!rs") do |msg|
  query = msg
  reply "http://rs.4chan.org/?s=" + URI.escape(query, /[^a-zA-Z0-9_-]/)
end
