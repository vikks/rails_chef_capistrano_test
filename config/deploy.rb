# config valid only for Capistrano 3.1
lock '3.3.5'

set :application, 'rails_chef_capistrano_test'
set :repo_url, "git@github.com:vikks/#{fetch(:application)}.git"

set :rvm_ruby_version, 'ruby-2.1.4'
set :default_env, { rvm_bin_path: "/home/bob/.rvm/bin", pg_config: "/usr/pgsql-9.4/bin"}
SSHKit.config.command_map[:rake] = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"

#set :bundle_env_variables,  { bundle_path: "/home/bob/.rvm/gems/ruby-2.1.4@global/bin" }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'
#set :deploy_to, "/home/#{fetch(:user)}/apps/application"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
 set :pty, true # capistrano-sidekiq requires it to be false

# Default value for :linked_files is []
 #set :linked_files, %w{
 #config/database.yml
                       #config/application.yml
                       #config/unicorn.rb}

# Default value for linked_dirs is []
 set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
 #set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Set of commands to be executed on server by root manually.

 namespace :deploy do

   %w[start stop restart].each do |command|
     desc "#{command} unicorn"
     task command do
       on roles(:app) do
         within "#{current_path}" do
           execute "service unicorn_#{fetch(:application)} #{command}"
         end
       end
     end
   end

   after :publishing, :restart

   after :restart, :clear_cache do
     on roles(:web), in: :groups, limit: 3, wait: 10 do
       # Here we can do anything such as:
       # within release_path do
       #   execute :rake, 'cache:clear'
       # end
     end
   end

 end
