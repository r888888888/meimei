=begin
define_plugin("!note") do |msg|
  msg =~ /(\S+) (.+)/
  dest = $1
  note = $2

  say @current_server, "MemoServ", "send #{dest} (from #{@current_from}) #{note}"
  say @current_server, @current_from, "Forwarded note to #{dest}"
end
=end
