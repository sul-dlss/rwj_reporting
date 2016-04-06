set :home_directory, "/home/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

# The only production server at the moment. A second will be added after the node is pupgraded
server 'libstream.stanford.edu', user: fetch(:user), roles: %w(app)

Capistrano::OneTimeKey.generate_one_time_key!

set :bundle_without, %w(development test).join(' ')
