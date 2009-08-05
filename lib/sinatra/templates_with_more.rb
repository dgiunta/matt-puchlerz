module Sinatra
  
  module TemplatesWithMore
    
    include Templates
    
    # Implementation of Rails-like partial templates for the Sinatra framework.
    # Adapted from: http://github.com/psyche/sinatra-partials
    # 
    # TODO: Abstract this a little more to render any type of partial. Initially 
    # thinking it'd be nice to have #haml_partial, #erb_partial, etc...
    # 
    def partial(template, options = {}, locals = {})
      path     = template.to_s.split(File::SEPARATOR)
      object   = path[-1].to_sym
      path[-1] = "_#{ path[-1] }"
      template = File.join(path).to_sym
      
      if collection = options.delete(:collection)
        collection.inject([]) do |buffer, member|
          # Not sure why, but the options local gets reset with every iteration
          # so we need to set :layout to false every time.
          options[:layout] = false
          locals[object]   = member
          buffer << haml(template, options, locals)
        end.join("\n")
      else
        options[:layout] = false
        haml(template, options, locals)
      end
    end
    
    private        
    
    # Overriding to recall the "current page" for use within any template
    # 
    def render(engine, template, options = {}, locals = {})
      @current_page ||= template
      super
    end
    
  end
  
  helpers TemplatesWithMore
  
end