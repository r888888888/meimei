require 'uri'

define_plugin("!dwiki") do |msg|
  tags = URI.escape(msg, /[^a-zA-Z0-9]/).gsub(/%20/, "+")
  reply "http://danbooru.donmai.us/wiki?query=#{tags}"
end
