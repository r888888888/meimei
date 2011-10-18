define_plugin("hanase") do |msg|
  @hanase ||= []
  @hanase << msg

  if @hanase.size > 3
    @hanase.shift
  end

  if @hanase == %w(HA NA SE)
    reply "nani kanchigai shiterunda."
    sleep 2
    reply "MADA ORE NO BATTLE PHASE WA SHUURYOU SHITENAIZE", false
  end
end
