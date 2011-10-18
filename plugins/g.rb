#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "json"
require "timeout"
require "cgi"

define_plugin("!g") do |msg|
  query = msg

  if query.any?
    begin
      Net::HTTP.start("ajax.googleapis.com", 80) do |http|
        resp = http.get("/ajax/services/search/web?v=1.0&q=" + URI.escape(query, /./))
        json = JSON.parse(resp.body)
        answers = json["responseData"]["results"].map {|x| "\00311" + CGI.unescapeHTML(x["titleNoFormatting"]) + " \00307" + URI.unescape(x["url"])}
        answers.each do |answer|
          reply answer
        end
      end
    rescue Timeout
      reply "timeout"
    rescue Exception => e
      reply e.to_s
    end
  end
end

