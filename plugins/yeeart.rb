define_plugin("yeeart") do |msg|
  next unless msg =~ /\by+e(e+)a+r+t+\b/i
  size = [$1.size, 400].min
  resp = "YE" + ("E" * (size + 1)) + "ART!"
  reply resp
end
