guard "rspec", :version => 2, :all_on_start => false,
               :all_after_pass => false, :bundler => false,
               :keep_failed => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end
