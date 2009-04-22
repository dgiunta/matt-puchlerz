require 'rubygems'
require 'sinatra'
# require 'active_support'
require 'haml'
gem 'chriseppstein-compass', '~> 0.4'
require 'compass'
require 'RedCloth'



#
# Configuration
# 

configure do
  
  Compass.configuration do |config|
    config.project_path = File.dirname __FILE__
    config.sass_dir     = File.join 'views', 'stylesheets'
  end
  
end



# 
# Load lib and app files
# 

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

%w[ lib app ].each do |dir| 
  Dir.glob("#{dir}/**/*.rb").sort.each { |file| load_or_require file }
end