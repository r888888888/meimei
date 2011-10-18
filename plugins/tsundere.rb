define_plugin("tsundere") do |msg|
  next unless msg =~ /don'?t get the wrong idea/i
  next unless msg =~ /it'?s not like/i
  reply "so tsundere <3"
end
