require 'rubygems'
require 'net/http'
require 'json'
require 'damerau-levenshtein'
require 'time_difference'

define_plugin("!eta") do |msg|
  query = msg

  if query.strip == ""
    reply "http://www.mahou.org/Showtime"
  else
    Net::HTTP.start("anime.yshi.org", 80) do |http|
      resp = http.get("/api/calendar/upcoming/all")
      if resp.code !~ /200/
        reply "Could not fetch web page, try again later"
        break
      end

      answer = "Show not found"
      json = JSON.parse(resp.body)
      best, score = nil, 1_000
      json.each do |show|
        d = DamerauLevenshtein.distance(show["title_name"].downcase, query)
        if d < score
          best = show
          score = d
        end
      end

      if best
        anime = best["title_name"]
        episode = best["count"]
        start_time = Time.at(best["start_time"].to_i)
        distance = TimeDifference.between(start_time, Time.now).in_general
        distance_s = "#{distance[:days]}d #{distance[:hours]}h #{distance[:minutes]}m"

        reply "ETA for #{anime} (ep #{episode}): #{distance_s}"
      end
    end
  end
end
