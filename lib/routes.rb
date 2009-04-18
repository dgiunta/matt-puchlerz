get '/' do
  haml :index
end

get '/stylesheets/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/screen", :sass => Compass.sass_engine_options
end