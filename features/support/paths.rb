module NavigationHelpers
  
  # Maps a static name to a static route.
  def path_to(page_name)
    case page_name
    when /the home page/
      '/'
    when /the works index page/
      '/'
    when /the work show page/
      "/works/#{ MattPuchlerz::Work.first.slug }"
    when /the blank work show page/
      "/works/theres-no-way-this-is-actually-going-to-be-a-work"
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
  
end

World(NavigationHelpers)