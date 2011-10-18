require 'rubygems'
require 'net/http'
require 'nokogiri'

define_plugin("!eta") do |msg|
  query = msg

  if query.strip == ""
    reply "http://www.mahou.org/Showtime"
  else
    Net::HTTP.start("www.mahou.org", 80) do |http|
      resp = http.get("/Showtime")
      if resp.code !~ /200/
        reply "Could not fetch web page, try again later"
        break
      end

      answer = "Show not found"
      doc = Nokogiri::HTML(resp.body)
      doc.xpath('//table[@summary="Currently Airing"]/tr/td/table/tr').each do |element|
        name = element.children[2].text
        eta = element.children[12].text
        if name =~ /#{query}/i
          answer = "ETA for #{name}: #{eta}"
          break
        end
      end

      if answer == "Show not found"
        doc.xpath('//table[@summary="Starting Soon"]/tr/td/table/tr').each do |element|
          name = element.children[2].text
          eta = element.children[16].text
          if name =~ /#{query}/i
            answer = "ETA for #{name}: #{eta}"
            break
          end
        end
      end

      reply answer
    end
  end
end
