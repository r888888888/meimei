require 'uri'

define_plugin("!dan") do |msg|
  tags = URI.escape(msg, /[^a-zA-Z0-9]/).gsub(/%20/, "+")

  if rand(100) == 0
    reply "WAKE UP"
    sleep 1
    reply "DAN!"
  end

  reply "http://danbooru.donmai.us/post?tags=#{tags}"
end
