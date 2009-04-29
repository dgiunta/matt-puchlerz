get '/' do
  @works = []
  @works << MattPuchlerz::Work.new(
    :title       => 'Title 1',
    :description => 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    :images      => ['image1.jpg']
  )
  @works << MattPuchlerz::Work.new(
    :title       => 'Title 2',
    :description => 'Incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
    :images      => ['image2.jpg', 'image2a.jpg']
  )
  @works << MattPuchlerz::Work.new(
    :title       => 'Title 3',
    :images      => ['image3.jpg', 'image3a.jpg', 'image3b.jpg']
  )
  
  @works = @works.select{ |w| w.viewable? }
  haml :index
end

get '/stylesheets/screen.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass :"stylesheets/screen", :sass => Compass.sass_engine_options
end