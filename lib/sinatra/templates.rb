module Sinatra
  
  module Templates
    
    private        
    
    # Changes a few of the default options passed to Haml.
    # 
    # TODO: Figure out a way to not completely override the method. Tried using 
    # alias_method but couldn't get rid of the "stack level too deep" error.
    def render_haml(template, data, options, &block)
      options[:options] ||= {}
      options[:options][:attr_wrapper] ||= '"'
      engine = ::Haml::Engine.new(data, options[:options])
      engine.render(self, options[:locals] || {}, &block)
    end
    
  end
  
end