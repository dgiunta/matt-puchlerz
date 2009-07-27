# Note the application's root for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

require 'rubygems'
require 'sinatra'
require 'sinatra/rest'

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

Dir.glob("#{ ROOT }/lib/**/*.rb").each { |file| load_or_require file }

include MattPuchlerz



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
  @works = Work.all
  haml :index
end

rest Work, :routes => :show

unless Sinatra::Application.environment == :production
  
  get '/admin' do
    redirect '/admin/works'
  end
  
  rest Work, :namespace => '/admin', :layout => :admin
  
end