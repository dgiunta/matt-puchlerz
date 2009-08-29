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
      "rm -f #{ current_path } && ln -s #{ latest_release } #{ current_path }",
      "mkdir -p #{ latest_release }/db #{ latest_release }/tmp"
    ].join('&&')
  end
  
  namespace :gems do
    
    desc 'Installs all necessary gems on the server.'
    remote_task :install do
      Rake::Task['gems:install'].invoke
    end

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

namespace :gems do
  
  desc 'Installs all necessary gems.'
  task :install do
    gems = [
      { :version => '2.3.2',  :name => 'activesupport' },
      { :version => '0.3.1',  :name => 'blindgaenger-sinatra-rest' },
      { :version => '0.10.0', :name => 'dm-core' },
      { :version => '0.10.0', :name => 'dm-migrations' },
      { :version => '0.10.0', :name => 'dm-types' },
      { :version => '0.10.0', :name => 'dm-is-list' },
      { :version => '0.10.0', :name => 'do_sqlite3' },
      { :version => '2.2.2',  :name => 'haml' },
      { :version => '1.0.0',  :name => 'rack' },
      { :version => '4.2.2',  :name => 'RedCloth' },
      { :version => '0.9.4',  :name => 'sinatra' },
    ]
    
    puts ''
    puts "Installing #{ gems.length } gems and their dependencies:"
    puts ''
    
    gems.each_with_index do |g, i|
      puts ''
      puts "[#{ i + 1 } of #{ gems.length }] #{ g[:name] }-#{ g[:version] }"
      run "sudo gem install --version #{ g[:version] } --include-dependencies --no-rdoc --no-ri --no-test #{ g[:name] }"
    end

    puts ''
    puts 'Done!'
  end
  
  # desc 'Syncs all necessary gems to the application server.'
  # task :sync do
  #   %w[ 
  #     unpack
  #     tar:create 
  #     tar:upload 
  #     tar:extract_uploaded 
  #     tar:delete_uploaded 
  #   ].each { |t| Rake::Task["gems:#{ t }"].invoke }
  # end
  # 
  # namespace :tar do
  # 
  #   desc 'Create a tar of all vendored gems.'
  #   task :create do
  #     puts ''
  #     puts 'Creating vendor.tar.gz...'
  #     `tar -czf vendor.tar.gz vendor/`
  #     puts 'Done!'
  #   end
  #   
  #   desc 'Extract the uploaded tar file.'
  #   remote_task :extract_uploaded do
  #     puts ''
  #     puts 'Extracting uploaded vendor.tar.gz...'
  #     run [ 
  #       "cd #{ current_release }", 
  #       "rm -rf vendor/", 
  #       "tar -xzf vendor.tar.gz" 
  #       ].join(' && ')
  #     puts 'Done!'
  #   end
  # 
  #   desc 'Delete the uploaded tar file.'
  #   remote_task :delete_uploaded do
  #     puts ''
  #     puts 'Deleting uploaded vendor.tar.gz...'
  #     run "rm #{ current_release }/vendor.tar.gz"
  #     puts 'Done!'
  #   end
  # 
  #   desc 'Upload the tar file.'
  #   remote_task :upload do
  #     puts ''
  #     puts 'Uploading vendor.tar.gz...'
  #     `scp vendor.tar.gz slicehost:#{ current_release }/vendor.tar.gz`
  #     puts 'Done!'
  #   end
  # 
  # end
  # 
  # desc 'Unpacks all required gems into vendor directory.'
  # task :unpack do
  #   gems = [
  #     { :version => '2.3.2',  :name => 'activesupport' },
  #     { :version => '2.0.2',  :name => 'addressable' },
  #     { :version => '0.3.1',  :name => 'blindgaenger-sinatra-rest' },
  #     { :version => '0.10.0', :name => 'data_objects' },
  #     { :version => '0.10.0', :name => 'dm-adjust' },
  #     { :version => '0.10.0', :name => 'dm-core' },
  #     { :version => '0.10.0', :name => 'dm-migrations' },
  #     { :version => '0.10.0', :name => 'dm-types' },
  #     { :version => '0.10.0', :name => 'dm-is-list' },
  #     { :version => '0.10.0', :name => 'do_sqlite3' },
  #     { :version => '0.3.1',  :name => 'english' },
  #     { :version => '0.9.13', :name => 'extlib' },
  #     { :version => '2.2.2',  :name => 'haml' },
  #     { :version => '1.0.0',  :name => 'rack' },
  #     { :version => '4.2.2',  :name => 'RedCloth' },
  #     { :version => '0.9.4',  :name => 'sinatra' },
  #     { :version => '1.0.0',  :name => 'stringex' },
  #   ]
  #   
  #   puts ''
  #   puts "Unpacking #{ gems.length } gems:"
  #   puts ''
  #   
  #   `rm -rf vendor/`
  #   `mkdir vendor`
  #   gems.each_with_index do |g, i|
  #     puts "#{ i + 1 }. #{ g[:name] }-#{ g[:version] }"
  #     `gem unpack --target vendor --version #{ g[:version] } #{ g[:name] }`
  #   end
  # 
  #   puts ''
  #   puts 'Done!'
  # end
  
end