# Note the application's root for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

require 'rubygems'
require 'sinatra'

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

Dir.glob('lib/**/*.rb').each { |file| load_or_require file }



# 
# Configuration
#

configure do

  set :root, ROOT
  
end



# 
# Helpers
# 

helpers do
  
  def page_title
    @page_title ||= 'Matt Puchlerz -- Designer & Web Developer'
  end
  
end



# 
# Routes
# 

get '/' do
  @works = []
  haml :index
end