# -*- encoding: utf-8 -*-
require File.expand_path('../lib/session_tracker', __FILE__)
require File.expand_path('../lib/session_tracker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joakim Kolsjö"]
  gem.email         = ["joakim.kolsjo@gmail.com"]
  gem.description   = %q{Track active user sessions in redis}
  gem.summary       = %q{Track active user sessions in redis}
  gem.homepage      = ""

  gem.files         = Dir["lib/**/*.rb", "README.md"]
  gem.name          = "session_tracker"
  gem.require_paths = ["lib"]
  gem.version       = SessionTracker::VERSION
  gem.add_development_dependency "rake"
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency "guard"
  gem.add_development_dependency "guard-rspec"
end
