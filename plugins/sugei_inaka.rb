define_plugin("sugei inaka") do |msg|
  next unless msg =~ /\bsugei inaka\b/i
  reply "sugei~", false
end
