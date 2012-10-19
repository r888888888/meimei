#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "json"
require "timeout"
require "cgi"

define_plugin("!gc") do |msg|
  app = "meimei"
  app_id = "WQJUTR-EXQT7VL45T"
  url = URI.parse("http://api.wolframalpha.com/v2/query?input=#{CGI.escape(msg)}&appid=#{app_id}&format=plaintext&includepodid=Result")

  begin
    Net::HTTP.start(url.host, url.port) do |http|
      resp = http.get(url.request_uri).body

      if resp =~ /queryresult success='false'/
        reply "Wolfram Alpha errored out"
      elsif resp =~ /<plaintext>(.+?)<\/plaintext>/m 
        answer = $1.strip
        answer = answer[0, 200]
        reply "#{msg} -> #{answer}"
      else
        reply "Wolfram Alpha doesn't seem to know"
      end
    end
  rescue Timeout
    reply "timeout"
  rescue Exception => e
    reply e.to_s
  end
end
