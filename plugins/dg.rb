require 'rubygems'
require 'json'
require 'open-uri'
require 'cgi'
require 'pp'

define_plugin("!dg") do |msg|
  api_key = CGI.escape("AIzaSyBbqMEONSx_cqrBhk0GXNbzZw_E3bNgNwQ")
  cx = CGI.escape("003806434433967703265:4z2lw9zljym")
  query = CGI.escape(msg)
  url = "https://www.googleapis.com/customsearch/v1?key=#{api_key}&q=#{query}&cx=#{cx}"
  text = open(url).read
  json = JSON.parse(text)
  urls = []

  if json["items"]
    urls = json["items"].select {|x| x["link"] =~ /us\/post/}.map {|x| x["link"]}
  end

  if urls.any?
    reply urls.slice(0, 5).join(" | ")
  else
    reply "No matches"
  end
end
