define_plugin("retard") do |msg|
  next unless msg =~ /^you're a retard, (.+)$/i
  reply "Marude hakuchi da na, #{$1}-san.", false
end
