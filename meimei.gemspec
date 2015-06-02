# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "meimei"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["r888888888"]
  s.date = "2015-06-02"
  s.description = "If all you need is a simple infobot and don't need a full RFC1459 implementation."
  s.email = "r888888888@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "cron.sh",
    "lib/meimei.rb",
    "lib/meimei/array_extensions.rb",
    "lib/meimei/client.rb",
    "lib/meimei/exception_dump.rb",
    "lib/meimei/persistent_hash.rb",
    "lib/meimei/server.rb",
    "meimei.gemspec",
    "plugins/an2.rb",
    "plugins/ann.rb",
    "plugins/autoping.rb",
    "plugins/cco.rb",
    "plugins/choose.rb",
    "plugins/courage.rb",
    "plugins/dan.rb",
    "plugins/dg.rb",
    "plugins/dwiki.rb",
    "plugins/eta.rb",
    "plugins/g.rb",
    "plugins/gc.rb",
    "plugins/godfinger.rb",
    "plugins/hammerhell.rb",
    "plugins/hanase.rb",
    "plugins/hellheaven.rb",
    "plugins/help.rb",
    "plugins/jtime.rb",
    "plugins/nai_ja_nai.rb",
    "plugins/note.rb",
    "plugins/ranking.rb",
    "plugins/reload.rb",
    "plugins/retard.rb",
    "plugins/rs.rb",
    "plugins/shiningfinger.rb",
    "plugins/shuffle.rb",
    "plugins/sugei_inaka.rb",
    "plugins/suki_dakara.rb",
    "plugins/ts.rb",
    "plugins/tsundere.rb",
    "plugins/tt.rb",
    "plugins/ttt.rb",
    "plugins/uptime.rb",
    "plugins/wawawa.rb",
    "plugins/weather.rb",
    "test/helper.rb",
    "test/test_meimei.rb"
  ]
  s.homepage = "http://github.com/r888888888/meimei"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Minimalistic IRC bot framework"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<rdoc>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<damerau-levenshtein>, [">= 0"])
      s.add_runtime_dependency(%q<time_difference>, [">= 0"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<damerau-levenshtein>, [">= 0"])
      s.add_dependency(%q<time_difference>, [">= 0"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<damerau-levenshtein>, [">= 0"])
    s.add_dependency(%q<time_difference>, [">= 0"])
  end
end

