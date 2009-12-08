# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)



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
set :deploy_to,   '/home/mattpuchlerz/Sites/staging.matt.puchlerz.com'

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

  desc 'Relink current release'
  remote_task :relink_current do
    run [
      "rm -f #{ current_path }",
      "ln -s #{ latest_release } #{ current_path }",
      "mkdir -p #{ latest_release }/db #{ latest_release }/tmp"
    ].join(' && ')
  end
  
end



# 
# App specific tasks
# 

namespace :db do

  desc 'Overwrite production database with staging database'
  task :staging_to_production do
    `cp db/staging.sqlite3 db/production.sqlite3`
  end

end

desc "Compile all *.less files"
task :less do
  FileUtils.mkdir_p "#{ ROOT }/public/stylesheets"
  
  less_files = Dir["#{ ROOT }/views/stylesheets/*.less"]
  puts "\nCompiling #{ less_files.length } files...\n\n"
  
  less_files.each_with_index do |less, i| 
    puts "#{ i + 1 }. #{ less.sub /.+\/(.+)/, '\1' } => #{ less.sub /.+\/(.+)less/, '\1css' }"
    `lessc #{ less } #{ less.sub /(.+)views(.+)less/, '\1public\2css' }`
  end
end