require 'rubygems'
require 'spec/expectations'
require 'webrat'
require File.join( File.dirname(__FILE__), '..', 'support', 'paths' )
require File.join( File.dirname(__FILE__), '..', '..', 'boot' )

Webrat.configure do |config|
  config.mode = :sinatra
end

World do
  session = Webrat::SinatraSession.new
  session.extend(Webrat::Matchers)
  session.extend(Webrat::HaveTagMatcher)
  session
end