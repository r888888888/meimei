#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "json"
require "timeout"
require "cgi"

define_plugin("!gc") do |msg|
  query = msg

  if query.any?
    begin
      Net::HTTP.start("www.google.com", 80) do |http|
        resp = http.get("/search?num=1&q=" + URI.escape(query, /[^a-zA-Z0-9]/))

        if resp.body =~ /<td.*?><h\d class=r.*?><b>(.*?)<\/b>/m
          result = $1.gsub(/<sup>/, "^").gsub(/&#215;/, "x").gsub(/<.+?>/, "")
          reply result
        else
          reply "Google doesn't seem to know"
        end         
      end
    rescue Timeout
      reply "timeout"
    rescue Exception => e
      reply e.to_s
    end
  end
end

