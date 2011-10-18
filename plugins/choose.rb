define_plugin("!choose") do |msg|
  if rand(100) <= 2
    reply "You decide."
  else
    choices = msg.split(/,\s*/)
    special = choices.grep(/only everyone is/)
    if special.any?
      reply special.pick_random
    else
      reply choices.pick_random
    end
  end
end
