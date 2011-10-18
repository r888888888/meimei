define_plugin("!shuffle") do |msg|
  reply msg.split(/,\s*/).sort {rand <=> rand}.join(", ")
end
