define_plugin("@5m autoping") do
  @servers.each do |server|
    server.write("PING #{server.hostname}")
  end
end
