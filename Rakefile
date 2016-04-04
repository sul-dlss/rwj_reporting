begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task default: :spec

rescue LoadError
  # this avoids getting bundler errors when running in production
end
