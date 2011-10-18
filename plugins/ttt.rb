require 'cgi'

define_plugin("!ttt") do |msg|
  reply "http://www.tokyotosho.info/search.php?terms=" + CGI.escape(msg)
end
