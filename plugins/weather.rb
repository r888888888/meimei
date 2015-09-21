require 'net/http'
require 'json'

define_plugin("!w") do |msg|
  api_key = "37f18195cbd147d0"
  query = msg

  begin
    Net::HTTP.start("api.wunderground.com", 80) do |http|
      param = nil

      if msg =~ /^\d+$/
        param = "#{msg}"
      elsif msg =~ /,/
        city, country = msg.split(/,/)
        param = "#{country.strip}/#{city.strip}".gsub(" ", "_")
      else
        param = msg.gsub(" ", "_")
      end

      resp = http.get("/api/#{api_key}/conditions/q/#{param}.json")
      json = JSON.parse(resp.body)

      if json["current_observation"].nil?
        reply "Unknown location. Usage: !w [us zip code | city, state | city, country]"
      else
        location = json["current_observation"]["display_location"]["full"]
        temperature = json["current_observation"]["temperature_string"]
        weather = json["current_observation"]["weather"]
        humidty = json["current_observation"]["relative_humidity"]
        response = "#{location}: #{temperature} - #{weather} - #{humidty} Humidity"
        reply response
      end
    end
  rescue Timeout
    reply "timeout"
  rescue Exception => e
    reply e.to_s
  end
end
