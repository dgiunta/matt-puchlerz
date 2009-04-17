require 'rubygems'
require 'sinatra'
require 'RedCloth'

def load_or_require(file)
  (Sinatra::Application.environment == :development) ? load(file) : require(file)
end

Dir["lib/*.rb"].each { |file| load_or_require file }