# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

# Add vendored gems to the load path
Dir['vendor/*/lib'].each { |path| $LOAD_PATH.unshift File.join(ROOT, path) }

require 'sinatra'
require 'sinatra/rest'
require 'less'

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
  
  DataMapper.setup :default, "sqlite3://#{ ROOT }/db/#{ Sinatra::Application.environment }.sqlite3"
  DataMapper.auto_upgrade!
  
end



# 
# Helpers
# 

helpers do
  
  def boolean_html(bool)
    bool ? '<span class="true">Yes</span>' : '<span class="false">No</span>'
  end
  
  def list_position_buttons(arr)
    [
      { :position => 'top',    :text => 'Move to Top',    :if => 0              },
      { :position => 'up',     :text => 'Move Up',        :if => 0              },
      { :position => 'down',   :text => 'Move Down',      :if => arr.length - 1 },
      { :position => 'bottom', :text => 'Move to Bottom', :if => arr.length - 1 }
    ]
  end
  
  def page_title
    @page_title ||= site_name
  end
  
  def site_name
    'Matt Puchlerz -- Designer & Web Developer'
  end
  
end



# 
# Routes
# 

get '/' do
  @works = Work.viewable
  haml :index
end

get '/works/:slug' do |slug|
  @work = Work.first :slug => slug
  halt 404 if @work.nil? or not @work.viewable?
  @page_title = "#{ @work.title } -- A Work by Matt Puchlerz"
  haml :'works/show'
end

get '/stylesheets/:filename.css' do |filename|
  content_type 'text/css', :charset => 'utf-8'
  file = File.open "#{ Sinatra::Application.views }/stylesheets/#{ filename }.less"
  Less.parse file
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
  
  get '/admin' do
    redirect '/admin/works'
  end
  
  rest Work, :layout => :admin, :namespace => '/admin' do

    before do |route|
      @position = params.delete 'position'
      super
    end
    
    after do |route|
      super
      if @position
        case @position
          when 'top';    @work.move :top
          when 'up';     @work.move :up
          when 'down';   @work.move :down
          when 'bottom'; @work.move :bottom
        end
        redirect url_for_works_index
      end
    end
    
  end
    
end