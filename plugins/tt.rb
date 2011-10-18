require 'timeout'
require 'net/http'
require 'cgi'

define_plugin("!tt") do |msg|
  begin
    query = msg

    if query =~ /^(anime|hentai|raw|music|manga|drama)/i
      type = $1.capitalize
      query = query.gsub(/^\S+ /, "")
    else
      type = nil
    end

    re_query = Regexp.new(Regexp.escape(query).gsub(/\\ /, ".+?"), Regexp::IGNORECASE)
    cgi_query = query.gsub(/ /, "+")
    Net::HTTP.start("www.tokyotosho.info", 80) do |http|
      resp = http.post("/search.php", "terms=#{cgi_query}")
      results = resp.body[/<table class="listing">(.+?)<\/table>/m, 1]
      rows = results.scan(/<tr.+?<\/tr>/m)
      matches = []
      if rows.any?
        rows[1..-1].each do |row|
          if type == nil || row =~ /alt="#{type}"/
              row =~ /<a rel="nofollow" type="application\/x-bittorrent" href="(.+?)">(.+?)<\/a>/
            url = CGI.unescapeHTML($1.to_s)
            desc = $2.to_s
            
            if desc =~ re_query
              matches << [desc, url]
            end
          end
        end
      end
      
      if matches.any?
        matches[0, 3].each do |m|
          reply "\00311#{m[0]}: \00307#{m[1]}"
        end
      else
        reply "No matches for #{query}"
      end
    end
  rescue Timeout::Error
    reply "time out"
  rescue Exception => e
    reply e.to_s
  end
end
