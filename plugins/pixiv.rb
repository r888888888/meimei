#!/usr/bin/env ruby

require 'cgi'

define_plugin("!pixiv") do |msg|
  query = msg
  @map ||= begin
    imap = {}
    script = File.open("/home/albert/meimei/plugins/65644.user.js", "r").read
    script.scan(/"(.+?)":\s+"(.+?)",/).each do |jp, en|
      imap[en] = jp
    end
    imap
  end

  matches = []
  perfect_match = nil
  regexp = Regexp.compile(Regexp.escape(query), Regexp::IGNORECASE)
  @map.each_key do |key|
    if key.downcase == query
      matches << [key, @map[key]]
      perfect_match = @map[key]
    elsif key =~ regexp
      matches << [key, @map[key]]
    end
  end

  if matches.size > 1
    reply "multiple matches found: " + matches.slice(0, 20).map {|x| x[0]}.join(', ')

    if perfect_match
      escaped_jp = CGI.escape(perfect_match)
      reply "exact match found (#{perfect_match}): http://www.pixiv.net/search.php?word=#{escaped_jp}&s_mode=s_tag"
    end
  elsif matches.size == 1
    en = matches.first[0]
    jp = matches.first[1]
    escaped_jp = CGI.escape(jp)
    reply "Searching #{en} (#{jp}): http://www.pixiv.net/search.php?word=#{escaped_jp}&s_mode=s_tag"
  else
    escaped_jp = CGI.escape(query)
    reply "No match found: http://www.pixiv.net/search.php?word=#{escaped_jp}&s_mode=s_tag"
  end
end
