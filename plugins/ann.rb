require 'net/http'
require 'cgi'
require 'uri'
require 'timeout'

define_plugin("!ann") do |msg|
  @ann_cache ||= {}

  name = msg

  if @ann_cache[name]
    reply @ann_cache[name]
    next
  end

  if name =~ /^(anime|manga|people|company) /
    type = $1
    name = name.gsub(/^(?:anime|manga|people|company) /, "")
  else
    type = "anime|manga|people|company"
  end

  uri = URI.parse("http://www.animenewsnetwork.com/encyclopedia/search.php?searchbox=#{CGI.escape(name)}")
  
  begin
    Net::HTTP.start("www.animenewsnetwork.com", 80) do |http|
      resp = http.get("/encyclopedia/search/name?q=" + CGI.escape(name))
      links = resp.body.scan(/<a href="\/encyclopedia\/(#{type})\.php\?id=(\d+)">(.+?)<\/a>/)
      matches = []
      links[0, 3].each do |l|
        matches << "#{l[0]}.php?id=#{l[1]}"
      end

      if matches.any?
        link = "http://www.animenewsnetwork.com/encyclopedia/#{matches[0]}"
        @ann_cache[name] = link
        reply link
      else
        reply "no matches found"
      end
    end
  rescue Timeout
    reply "timeout"
  rescue Exception => e
    reply e.to_s
  end
end
