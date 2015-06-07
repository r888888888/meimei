define_plugin("domo") do |msg|
  next unless msg =~ /\bdou?mo\b/i and msg =~ /\bdesu\b/i

  if msg =~ /hajimemashite/i
    reply "DOMO. HAJIMEMASHITE. MEIMEI DESU.", false
  elsif msg =~ /meimei-san[.!]?\s+(.+?)\s+desu/i
    reply "DOMO #{$1.upcase.strip}-SAN. MEIMEI DESU.", false
  elsif msg =~ /dou?mo[.!]?\s+(.+?)\s+desu/i
    reply "DOMO #{$1.upcase.strip}-SAN. MEIMEI DESU.", false
  elsif msg =~ /meimei-san/i
    reply "DOMO #{@current_from.upcase}-SAN. MEIMEI DESU.", false
  end
end
