require 'timezone'

define_plugin("!jtime") do
  timezone = Timezone::Zone.new(:zone => "Asia/Tokyo")
  reply "It is currently #{timezone.strftime('%c')} in Tokyo."
end
