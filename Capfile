# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rvm'
require 'capistrano/puma'
require 'capistrano/rbenv'

# install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

set :rbenv_type, :user
set :rbenv_ruby, '3.0.2'


Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
