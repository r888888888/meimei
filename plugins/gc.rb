#!/usr/bin/env ruby

require "rubygems"
require "net/http"
require "uri"
require "json"
require "timeout"
require "cgi"
require "nokogiri"
require "pry"

define_plugin("!gc") do |msg|
  app = "meimei"
  app_id = "WQJUTR-EXQT7VL45T"
  assumption = nil

  if msg =~ /\bassume (\S+)/
    assumption = $1
    msg = msg.sub(/\bassume \S+/, "").strip
  end

  url = URI.parse("http://api.wolframalpha.com/v2/query?input=#{CGI.escape(msg)}&appid=#{app_id}&format=plaintext&excludepodid=Input&assumption=#{assumption}")

  begin
    Net::HTTP.start(url.host, url.port) do |http|
      resp = http.get(url.request_uri).body
      doc = Nokogiri::XML(resp)
      answers = []

      doc.css("pod[error='false'] plaintext").each do |plaintext|
        answers << plaintext.inner_html.strip
      end

      answers.reject! {|x| x.empty?}

      if answers.any?
        answer_text = answers.first.slice(0, 450)
        reply "#{msg} -> #{answer_text}"
      else
        reply "I don't know"
      end
    end

    if answers.empty? 
      if assumption.nil? && doc.css("assumption").any?
        descs = doc.css("assumption value").map {|x| "#{msg} assume #{x.attr('input')}"}
        reply "try also: " + descs.join(", ").slice(0, 450)
      elsif doc.css("didyoumean").any?
        descs = doc.css("didyoumean").map {|x| x.inner_html.strip}
        reply "did you mean: " + descs.join(", ").slice(0, 450)
      end
    end

  rescue Timeout
    reply "timeout"
  rescue Exception => e
    reply e.to_s
  end
end
