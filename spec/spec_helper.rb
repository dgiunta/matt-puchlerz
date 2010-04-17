ENV['RACK_ENV'] = 'test'

# Machinist
require 'sham'
require 'faker'
require File.dirname(__FILE__) + '/machinist_attributor'

# Sinatra app
require File.dirname(__FILE__) + '/../app'

# Machinist blueprints
require File.dirname(__FILE__) + '/blueprints'

# RSpec
require 'spec'
Spec::Runner.configure do |config|
  config.before(:all)   { Sham.reset(:before_all)  }
  config.before(:each)  { Sham.reset(:before_each) }
end
