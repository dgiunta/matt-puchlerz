# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

# Require bundled gems
require 'rubygems'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

# Require everything in the lib directory
Dir["#{ ROOT }/lib/**/*.rb"].each { |file| require file }

# Make it easier to work within my namespace
include MattPuchlerz



# 
# Configuration
#

configure do

  set :root, ROOT
  set :haml, { :attr_wrapper => '"', :format => :html5 }
  
  DataMapper.setup :default, 'sqlite3::memory:'
  DataMapper.auto_migrate!
  YAML.load_file("#{ ROOT }/db/works.yaml").each { |attributes| Work.new(attributes).save }
  
end

configure :development do
   
  use Sinatra::Reloader
  
end



# 
# Helpers
# 

helpers do
  
  def mtime public_file
    path = Sinatra::Application.public + public_file
    "#{ public_file }?#{ File.mtime(path).to_i.to_s }" rescue public_file
  end
  
  def page_title
    @page_title ||= site_name
    @page_title = strip_tags @page_title
    @page_title + " (#{ Sinatra::Application.environment })" unless Sinatra::Application.environment == :production
  end
  
  def site_name
    'Matt Puchlerz: Designer &amp; Web Developer'
  end
  
  def site_name_pronunciation
    'Matt&bull;Puch&bull;lerz |mat po&#0333;ch l&#0601;rz|'
  end
  
end



# 
# Routes
# 

before do
  response['Cache-Control'] = 'public, max-age=3600' 
end

get '/' do
  @works = Work.viewable
  etag @works
  haml :index
end

get '/works/:slug' do |slug|
  @work = Work.first :slug => slug
  halt 404 if @work.nil? or not @work.viewable?
  etag @work
  @page_title = "#{ @work.title } &mdash; A Work by Matt Puchlerz"
  haml :'works/show'
end



# 
# Non-Production Routes
# 

unless Sinatra::Application.environment == :production

  get '/html_elements' do
    @table_rows = [
      { :id => 1123, :price => 4.99, :qty => 1, :name => 'Peanut Butter' },
      { :id => 4563, :price => 1.49, :qty => 2, :name => 'Dozen Eggs'    },
      { :id => 2345, :price => 2.95, :qty => 4, :name => 'Cereal'        },
      { :id => 8358, :price => 3.43, :qty => 1, :name => 'Dish Soap'     },
      { :id => 9432, :price => 0.99, :qty => 3, :name => 'Bananas'       },
      { :id => 1456, :price => 2.19, :qty => 1, :name => 'Quaker Oats'   },
    ]
    haml :html_elements
  end
        
end