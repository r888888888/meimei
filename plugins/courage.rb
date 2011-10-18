define_plugin("courage") do |msg|
  next unless msg =~ /the chance .+ is (?:only )?(\d+(?:\.\d+)?)%/i
  
  if $1.to_f < 100
    reply "WITH COURAGE WE CAN MAKE IT 100%!!", false
  end
end
