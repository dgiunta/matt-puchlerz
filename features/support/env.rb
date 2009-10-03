ENV['RACK_ENV'] = 'test'

# Sinatra app
require File.join( File.dirname(__FILE__), *%w[ .. .. app ] )

# RSpec matchers
require 'spec/expectations'


# 
# Webrat configuration
# 

require 'webrat'
require File.join( File.dirname(__FILE__), *%w[ . paths ] )

Webrat.configure do |config|
  config.mode = :rack
end

# Disable Webrat logging
module Webrat::Logging; def debug_log(message); end; end



# 
# Cucumber configuration
# 

module NeedsThisStuff

  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers
  include Webrat::HaveTagMatcher
  
  def app
    Sinatra::Application
  end

  Webrat::Methods.delegate_to_session :response

end

World NeedsThisStuff

Before do
  DataMapper.auto_migrate!
end