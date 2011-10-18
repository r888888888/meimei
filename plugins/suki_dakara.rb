define_plugin("suki dakara") do |msg|
  next unless msg =~ /^(.+?) suki dakara$/ && @current_from != "meimei"
  reply "KONO #{$1.upcase.strip} GA SUKI DAKARA!!!", false
end
