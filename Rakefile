begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
  # this avoids getting bundler errors when running in production
end

desc "Generate channel usage reports for [yymmdd,yymmdd] inclusive"
task :reports, [:start_date, :end_date] do |_t, args|
  lib = File.expand_path('../lib', __FILE__)
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
  require 'rwj_reporter'
  rr = RwjReporter.new(args[:start_date], args[:end_date])
  rr.print_reports_for_dates
end

task default: [:spec, :rubocop]
