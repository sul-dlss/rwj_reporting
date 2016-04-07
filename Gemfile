source 'https://rubygems.org'

gem 'rake'

# Coveralls gem for code coverage reporting
gem 'coveralls', require: false

group :development, :test do
  gem 'dlss_cops' # rubocop rules
  gem 'rspec'
#  gem 'rspec-expectations'
end

group :deployment do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-bundler'
  gem 'dlss-capistrano'
end
