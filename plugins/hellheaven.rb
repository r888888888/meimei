define_plugin("hell and heaven") do |msg|
  next unless msg == "HELL"
  reply "ANDO", false
  sleep 1
  reply "HEAVEN!", false
end
