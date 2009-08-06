ENV['RACK_ENV'] = 'test'

# Machinist
require 'machinist/data_mapper'
require 'sham'
require 'faker'

# Sinatra app
require File.join( File.dirname(__FILE__), *%w[ .. app ] )

# Machinist blueprints
require File.join( File.dirname(__FILE__), 'blueprints' )

# RSpec
require 'spec'
Spec::Runner.configure do |config|
  config.before(:all)   { Sham.reset(:before_all)  }
  config.before(:each)  { Sham.reset(:before_each) }
end

# Recreate the database
DataMapper.auto_migrate!