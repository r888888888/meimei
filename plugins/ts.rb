require 'cgi'
require 'rubygems'
require 'json'

define_plugin("!ts") do |msg|
  Net::HTTP.start("search.twitter.com", 80) do |http|
    resp = http.get("/search.json?rpp=3&q=" + CGI.escape(msg), {"User-Agent" => "meimei"})

    if resp.content_type == "application/json"
      results = JSON.parse(resp.body)["results"].map {|x|
        x["from_user"] + ": " + CGI.unescapeHTML(x["text"])
      }

      if results.empty?
        reply "No matches"
      else
        results[0, 3].each do |result|
          reply result
        end
      end
    else
      reply "Twitter is overloaded"
    end
  end
end
