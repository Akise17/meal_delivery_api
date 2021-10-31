def current_git_branch
    branch = `git symbolic-ref HEAD 2> /dev/null`.strip.gsub(/^refs\/heads\//, '')
    # if ENV.staging?
    #   branch ="internal_dashboard"
    # elsif ENV.production?
    #   branch "Transaction"
    # end
      
    puts "Deploying branch #{red branch}"
    branch
  end
  
  def red(str)
    "\e[31m#{str}\e[0m"
  end
  
  # set :branch, current_git_branch
  ## Defaults:
  # set :scm,           :git
  # set :branch,        :master
  # set :format,        :pretty
  # set :log_level,     :debug
  # set :keep_releases, 5
  # namespace :initial do
  # end 
  
  ## Linked Files & Directories (Default None):
  set :linked_dirs,  %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/spree}
  # append :linked_files, 'config/database.yml', 'config/nginx.conf'
  # set :linked_files, fetch(:linked_files, []).push('config/database.yml')
  # set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/nginx.conf')
  # set :linked_files, %w{config/database.yml config/nginx.conf}
  set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
  # set :linked_dirs, %w{tmp/pids tmp/cache public/system}
  # set :linked_dirs, fetch(:linked_dirs, []).push('public/system')
  
  set :passenger_environment_variables, { :path => '/path-to-passenger/bin:$PATH' }
  set :passenger_restart_command, '/path-to-passenger/bin/passenger-config restart-app'
  
  namespace :puma do
    desc 'Create Directories for Puma Pids and Socket'
    task :make_dirs do
      on roles(:app) do
        execute "mkdir #{shared_path}/tmp/sockets -p"
        execute "mkdir #{shared_path}/tmp/pids -p"
      end
    end
  
    before :start, :make_dirs
  end
  
  namespace :deploy do
    desc "Make sure local git is in sync with remote."
    task :check_revision do
      on roles(:app) do
        # task :symlink do
        #   puts "Create Symlink"
        #   run "ln -nfs #{shared_path}/config/nginx.conf #{release_path}/config/nginx.conf"
        #   run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
        # end
        unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
          puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
          puts "Run `git push` to sync changes."
          # exit
        end
      end
      
    end
  
    desc 'Initial Deploy'
    task :initial do
      on roles(:app) do
        before 'deploy:restart', 'puma:start'
        invoke 'deploy'
      end
    end
  
    desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        invoke 'puma:restart'
      end
    end
  
    before :starting,     :check_revision
    after  :finishing,    :compile_assets
    after  :finishing,    :cleanup
    after  :finishing,    :restart
  end
  
  # ps aux | grep puma    # Get puma pid
  # kill -s SIGUSR2 pid   # Restart puma
  # kill -s SIGTERM pid   # Stop puma