# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

set :user, -> { 'bob'}
set :rails_env, :production
server '128.199.253.22', user: "#{fetch(:user)}", roles: %w{web app db}, primary: :true

set :bundle_cmd, 'source $HOME/.bash_profile && bundle'
set :bundle_gemfile, -> { release_path.join('Gemfile')}
set :bundle_dir,     -> { shared_path.join('bundle')  }
set :bundle_flags,    '--deployment' # "--deployment --quiet"
set :bundle_without, %w{ development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin')}
set :bundle_roles, :all

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
fetch(:default_env).merge!(rails_env: :production)
set :ssh_options, {
   keys: %w(~/.ssh/id_rsa),
   forward_agent: true,
   port: 22
   }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
