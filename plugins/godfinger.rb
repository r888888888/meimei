define_plugin("god finger") do |msg|
  next unless msg =~ /ore no kono te ga makka ni moeru/i

  reply "Shouri o tsukameto todoroki sakebu!", false
  sleep 1
  reply "BAKUNETSU", false
  sleep 1
  reply "GOOOOOOOOOOOOOOOD FIIIIIIINGAAAAAAAAAAAAAA!!!!!!", false
end
