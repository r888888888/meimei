define_plugin("!jtime") do
  Net::HTTP.start("www.google.com", 80) do |http|
    resp = http.get("/search?q=tokyo+time")
    html = resp.body
    html =~ /<b>(\d+):(\d+)(am|pm)<\/b>/

    reply "It is currently #{$1}:#{$2} #{$3} in Japan."
  end
end
