# 
# App specific tasks
# 

namespace :db do

  desc 'Overwrite production database with staging database'
  task :staging_to_production do
    `cp db/staging.sqlite3 db/production.sqlite3`
  end

end

namespace :gems do
  
  desc 'Unpacks all required gems into vendor directory'
  task :unpack do
    gems = [
      { :version => '2.3.2',  :name => 'activesupport' },
      { :version => '0.3.1',  :name => 'blindgaenger-sinatra-rest' },
      { :version => '0.10.0', :name => 'dm-core' },
      { :version => '0.10.0', :name => 'dm-migrations' },
      { :version => '0.10.0', :name => 'dm-types' },
      { :version => '0.10.0', :name => 'dm-is-list' },
      { :version => '0.10.0', :name => 'do_sqlite3' },
      { :version => '0.9.13', :name => 'extlib' },
      { :version => '1.0.0',  :name => 'rack' },
      { :version => '4.2.2',  :name => 'RedCloth' },
      { :version => '0.9.4',  :name => 'sinatra' },
    ]
    
    puts ''
    puts "Unpacking #{ gems.length } gems:"
    puts ''
    
    `mkdir vendor`
    gems.each_with_index do |g, i|
      puts "#{ i + 1 }. #{ g[:name] }-#{ g[:version] }"
      `gem unpack --target vendor --version #{ g[:version] } #{ g[:name] }`
    end

    puts ''
    puts 'Done!'
  end
  
end



# 
# Vlad the Deployer
# 

require 'hoe'
require 'vlad/core'
require 'vlad/passenger'
require 'vlad/apache'
require 'vlad/git'

set(:latest_release) { deploy_timestamped ? current_release : release_path }

set :repository,  'ssh://puchlerz@lira.dreamhost.com/~/git.puchlerz.com/matt.puchlerz.com.git'
set :revision,    'origin/staging'

set :web_command, 'apache2ctl'
set :sudo_prompt, /^.*password for .*:/

set :domain,      '67.23.1.68'
set :ssh_flags,   [ '-p 30022' ]
set :deploy_to,   "/home/mattpuchlerz/Sites/staging.matt.puchlerz.com"

namespace :vlad do

  Rake.clear_tasks 'vlad:start_web'
  desc '(Re)Start the web servers'
  remote_task :start_web, :roles => :web do
    run "sudo #{ web_command } restart"
  end

  Rake.clear_tasks 'vlad:stop_web'
  desc 'Stop the web servers'
  remote_task :stop_web, :roles => :web do
    run "sudo #{ web_command } stop"
  end

end