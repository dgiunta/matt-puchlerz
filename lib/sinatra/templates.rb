module Sinatra
  module Templates
    
    # Implementation of Rails-like partial templates for the Sinatra framework.
    # Adapted from: http://github.com/psyche/sinatra-partials
    # 
    # TODO: Abstract this a little more to render any type of partial. Initially 
    # thinking it'd be nice to have #haml_partial, #erb_partial, etc...
    def partial(template, options)
      options.merge!(:layout => false)
      
      path     = template.to_s.split(File::SEPARATOR)
      object   = path[-1].to_sym
      path[-1] = "_#{path[-1]}"
      template = File.join(path).to_sym
      
      if collection = options.delete(:collection)
        collection.inject([]) do |buffer, member|
          buffer << haml(template, options.merge(:locals => {object => member}))
        end.join("\n")
      else
        haml(template, options)
      end
    end
    
    private        
    
    # Changes a few of the default options passed to Haml.
    # 
    # TODO: Figure out a way to not completely override the method. Tried using 
    # alias_method but couldn't get rid of the "stack level too deep" error.
    def render_haml(template, data, options, &block)
      options[:options] ||= {}
      options[:options][:attr_wrapper] ||= '"'
      options[:options][:format] ||= :html5
      engine = ::Haml::Engine.new(data, options[:options])
      engine.render(self, options[:locals] || {}, &block)
    end
    
  end
end