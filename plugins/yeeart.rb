define_plugin("yeeart") do |msg|
  next unless msg =~ /\b(y+)(ee+)(a+)(r+)(t+)\b/i
  ys = [$1.size, 50].min
  es = [$2.size, 300].min
  as = [$3.size, 50].min
  rs = [$4.size, 50].min
  ts = [$5.size, 50].min
  resp = ("Y" * (ys + 1)) + ("E" * (es + 1)) + ("A" * (as + 1)) + ("R" * (rs + 1)) + ("T" * (ts + 1)) + "!"
  reply resp
end
