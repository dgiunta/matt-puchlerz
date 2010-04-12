require 'net/ssh'

module Rake
  module Deployer
    
    @pretend = false
    
    @settings = {
      :branch      => 'master',
      :date_string => Time.now.strftime('%Y-%m-%d-%H-%M-%S'),
      :deploy_path => nil,
      :host        => nil,
      :repository  => nil,
      :revision    => 'HEAD',
      :username    => nil,
    }
    
    def self.setup settings
      [ :host, :username, :deploy_path, :repository ].each do |key|
        if not settings[key] or settings[key].strip.empty?
          raise ArgumentError, "You must pass a valid :#{ key } when calling Rake::Deployer#setup"
        end
      end
      
      @settings.merge! settings
    end
    
    def self.settings
      @settings
    end
    
    def self.ssh_desc str
      puts "\n#{ str }..."
    end

    def self.ssh_exec *args
      cmd = args.join ' && '
      puts cmd 
      return if @pretend
      
      Net::SSH.start(settings[:host], settings[:username]) do |ssh|
        output = ssh.exec!(cmd)
        puts output if output
        ssh.loop
      end
      
      puts 'Done.'
    end
    
    task :pretend do
      @pretend = true
    end
    
    desc 'Deploy the latest revision of the app'
    task :deploy => [ :'deploy:update', :'deploy:bundle_gems', :'deploy:restart' ]
    namespace :deploy do

      desc 'Bundle gems for the checked out branch'
      task :bundle_gems do
        ssh_desc 'Bundling gems'
        ssh_exec "cd #{ settings[:deploy_path] }/current/",
                 "bundle install"
      end

      desc 'Restart Passenger'
      task :restart do
        ssh_desc 'Restarting Passenger'
        ssh_exec "cd #{ settings[:deploy_path] }/current/",
                 "mkdir -p tmp/",
                 "touch tmp/restart.txt"
      end

      desc 'Initial setup of your server'
      task :setup => [ :'setup:directories', :'setup:app' ]
      namespace :setup do

        desc 'Create the directory structure'
        task :directories do
          ssh_desc 'Creating directory structure'
          ssh_exec "mkdir -p #{ settings[:deploy_path] }",
                   "cd #{ settings[:deploy_path] }",
                   "mkdir -p shared/log",
                   "mkdir -p shared/system"
        end

        desc 'Create the app by cloning the source from Git'
        task :app do
          ssh_desc 'Cloning the source from Git'
          ssh_exec "cd #{ settings[:deploy_path] }",
                   "git clone #{ settings[:repository] } current"
        end

      end

      desc 'Update to the latest source from Git'
      task :update do
        ssh_desc "Updating your code to the #{ settings[:revision] } revision"
        ssh_exec "cd #{ settings[:deploy_path] }/current/",
                 "git checkout #{ settings[:branch] }",
                 "git pull",
                 "git reset --hard #{ settings[:revision] }",
                 # "git submodule update --init",
                 "git checkout -b deployed-#{ settings[:date_string] }"
      end

      # TODO: Cleanup deployment branches
      # $ DEPLOYED=`git branch -l | grep deployed`
      # $ for x in $DEPLOYED; do git branch -d $x; done

    end
      
  end # Deployer
end # Rake