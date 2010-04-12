# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)



# 
# Rake Deployer
# 

require 'rake-deployer'

Rake::Deployer.setup(
  :host        => 'slicehost',
  :username    => 'mattpuchlerz',
  :deploy_path => '/home/mattpuchlerz/Sites/matt.puchlerz.com',
  :repository  => 'git@github.com:mattpuchlerz/matt-puchlerz.git'
)



# 
# App specific tasks
# 

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