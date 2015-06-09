#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "json"
require "timeout"
require "cgi"

define_plugin("!g") do |msg|
  query = msg
  api_key = "AIzaSyBbqMEONSx_cqrBhk0GXNbzZw_E3bNgNwQ"

  if query =~ /\S/
    begin
      Net::HTTP.start("www.googleapis.com", 443, :use_ssl => true) do |http|
        resp = http.get("/customsearch/v1?cx=003806434433967703265:eltrj5arw88&key=#{api_key}&q=" + URI.escape(query, /./))
        json = JSON.parse(resp.body)
        answer = json["items"][0]
        reply "#{answer['title']} -> #{answer['link']}"
      end
    rescue Timeout
      reply "timeout"
    rescue Exception => e
      reply e.to_s
    end
  end
end

