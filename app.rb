# Note the application's root for convenience
ROOT = File.expand_path File.dirname(__FILE__) unless defined?(ROOT)

require 'rubygems'
require 'sinatra'
require 'datamapper'
# require 'active_support/core_ext/blank'

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
  @works << MattPuchlerz::Work.new(
    :title       => 'Title 1',
    :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    :images      => ['image1.jpg']
  )
  # @works << MattPuchlerz::Work.new(
  #   :title       => 'Title 2',
  #   :description => 'Incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
  #   :images      => ['image2.jpg', 'image2a.jpg']
  # )
  # @works << MattPuchlerz::Work.new(
  #   :title       => 'Title 3',
  #   :images      => ['image3.jpg', 'image3a.jpg', 'image3b.jpg']
  # )
  # 
  # @works = @works.select{ |w| w.viewable? }
  haml :index
end