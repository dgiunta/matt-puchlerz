module NavigationHelpers
  
  # Maps a static name to a static route.
  def path_to(page_name)
    case page_name
    when /the home page/
      '/'
    when /the portfolio page/
      '/' #'/#works'
    when /the work details page/
      '/works/1' #'/#works'
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
  
end

World(NavigationHelpers)