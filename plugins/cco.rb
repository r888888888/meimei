define_plugin("cco") do |msg|
  next unless msg =~ /\bCCO\b/
  reply "MAKOTO CCO YOUR HEAD BELONGS TO ME"
end
