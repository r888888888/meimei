define_plugin("!weather") do |msg|
  query = msg

  if query.any?
    begin
      Net::HTTP.start("www.google.com", 80) do |http|
        resp = http.get("/search?num=1&q=weather+for+" + URI.escape(query, /[^a-zA-Z0-9]/))
        if resp.body =~ /<table class="ts std">.+?<b>Weather<\/b> for <b>(.+?)<\/b>/m

          result = "Weather for " + $1 + ": "

          if resp.body =~ />Current: <b>(.+?)</m
            result = result + $1 + ", "
          end

          if resp.body =~ /<div style="font-size:140%"><b>(.+?)<\/b>/m
            result = result + $1 + ", "
          end

          if resp.body =~ />(Wind: .+?)</m
            result = result + $1 + ", "
          end

          if resp.body =~ />(Humidity: .+?)</m
            result = result + $1
          end

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
