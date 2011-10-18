define_plugin("shining finger") do |msg|
  next unless msg =~ /ore no kono te ga hikatte unaru/i

  reply "Omae o taose to kagayaki sakebu!", false
  sleep 1
  reply "HISSATSU!", false
  sleep 1
  reply "SHIIIIIINNNIIIIIIIINNNNNGGGGG FIIIIINNNNNGGGAAAAAAAA!!!!!!!", false
end
