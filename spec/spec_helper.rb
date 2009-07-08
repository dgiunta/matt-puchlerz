ENV['RACK_ENV'] = 'test'

# Sinatra app
require File.join( File.dirname(__FILE__), *%w[ .. app ] )

# RSpec
require 'spec'

# Recreate the database
DataMapper.auto_migrate!