guard 'rspec', :all_on_start => false,
               :all_after_pass => false,
               :failed_mode => :keep,
               :cmd => "bundle exec rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end
