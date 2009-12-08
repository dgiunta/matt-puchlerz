# Note the application's root directory for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

# Add bundled gems to the load path, and require them
require "#{ ROOT }/vendor/gems/environment"
Bundler.require_env

require 'action_controller/vendor/html-scanner'

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
  
  DataMapper.setup :default, "sqlite3::memory:"
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
  
  def boolean_html bool
    bool ? '<span class="true">Yes</span>' : '<span class="false">No</span>'
  end
  
  def list_position_buttons arr
    [
      { :position => 'top',    :text => 'Move to Top',    :disable_if => 0              },
      { :position => 'up',     :text => 'Move Up',        :disable_if => 0              },
      { :position => 'down',   :text => 'Move Down',      :disable_if => arr.length - 1 },
      { :position => 'bottom', :text => 'Move to Bottom', :disable_if => arr.length - 1 }
    ]
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

get '/' do
  @works = Work.viewable
  haml :index
end

get '/works/:slug' do |slug|
  @work = Work.first :slug => slug
  halt 404 if @work.nil? or not @work.viewable?
  @previous_item = @work.previous_item
  @next_item = @work.next_item
  @page_title = "#{ @work.title } &mdash; A Work by Matt Puchlerz"
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
  
  get '/admin/works' do
    @works = Work.all
    haml :'works/admin_index', :layout => :layout_admin
  end
  
  get '/admin/works/new' do
    @work = Work.new
    haml :'works/admin_new', :layout => :layout_admin
  end
  
  post '/admin/works' do
    @work = Work.new params
    @work.save
    redirect '/admin/works'
  end
  
  get '/admin/works/:id/edit' do
    @work = Work.get params[:id]
    haml :'works/admin_edit', :layout => :layout_admin
  end
  
  put '/admin/works/:id' do
    @work = Work.get params[:id]
    params.delete '_method'
    position = params.delete 'position'
    @work.update_attributes params
    @work.move position.to_sym if position
    redirect '/admin/works'
  end
  
  delete '/admin/works/:id' do
    @work = Work.get params[:id]
    @work.destroy!
    redirect '/admin/works'
  end
      
end