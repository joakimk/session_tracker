# -*- encoding: utf-8 -*-
require File.expand_path("../lib/session_tracker", __FILE__)
require File.expand_path("../lib/session_tracker/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joakim Kolsjö"]
  gem.email         = ["joakim.kolsjo@gmail.com"]
  gem.description   = %q{Track active user sessions in redis}
  gem.summary       = %q{Track active user sessions in redis}
  gem.homepage      = ""
  gem.metadata      = { "rubygems_mfa_required" => "true" }

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "session_tracker"
  gem.require_paths = ["lib"]
  gem.version       = SessionTracker::VERSION
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "barsoom_utils"
  gem.add_development_dependency "rubocop"
end
