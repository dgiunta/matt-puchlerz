# Note the application's root for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

require 'rubygems'
require 'sinatra'

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

Dir.glob("#{ ROOT }/lib/**/*.rb").each { |file| load_or_require file }



# 
# Configuration
#

configure do

  set :root, ROOT
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_upgrade!
  
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
  @works = MattPuchlerz::Work.all
  haml :index
end

get '/works/:id' do
  @work = MattPuchlerz::Work.get params[:id]
  haml :work_show
end