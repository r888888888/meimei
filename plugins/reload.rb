define_plugin("!reload") do |msg|
  load_plugins()
  reply "Plugins reloaded", false
end
