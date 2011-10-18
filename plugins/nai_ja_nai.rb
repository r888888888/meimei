define_plugin("nai ja nai") do |msg|
  next unless msg =~ /\bnai ja nai\b/i
  reply "NAI JA NAI!!!", false
end
