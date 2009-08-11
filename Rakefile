# 
# Vlad the Deployer
# 

require 'vlad/core'
require 'vlad/passenger'
require 'vlad/apache'
require 'vlad/git'

set :repository, 'ssh://puchlerz@lira.dreamhost.com/~/git.puchlerz.com/matt.puchlerz.com.git'
set :revision,   'origin/staging'

set :domain,     '67.23.1.68'
set :ssh_flags,  [ '-p 30022' ]
set :deploy_to,  "/home/mattpuchlerz/Sites/staging.matt.puchlerz.com"


# 
# App specific tasks
# 

namespace :db do

  desc 'Overwrite production database with staging database'
  task :staging_to_production do
    `cp db/staging.sqlite3 db/production.sqlite3`
  end

end