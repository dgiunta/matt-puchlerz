get '/' do
  haml :index
end

get '/stylesheet.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :stylesheet
end

get '/users/:name' do |name|
  @name = name.split('_').map { |word| word.capitalize }.join(' ')
  haml :'users/show'
end