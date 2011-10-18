define_plugin("wawawa") do |msg|
  if msg =~ /\bWA\s*WA\s*WA\b/i
    reply "wasuremono~", false
  end
end
