#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new("spec") do |t|
  t.pattern = "spec/**/*.rb"
end

task :default => :spec
