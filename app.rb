require 'rubygems'
require 'sinatra'
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
# Load application files
# 

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

Dir["lib/*.rb"].each { |file| load_or_require file }