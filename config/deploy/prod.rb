# The only production server at the moment. A second will be added after the node is pupgraded
server 'rwjazz-stream.stanford.edu', user: 'media', roles: %w(app)

Capistrano::OneTimeKey.generate_one_time_key!

set :bundle_without, %w(development test).join(' ')
