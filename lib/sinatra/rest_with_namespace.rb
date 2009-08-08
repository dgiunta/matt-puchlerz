module Sinatra
  
  module RestWithNamespace
    
    include REST
   
    def parse_args(model_class, options)
      super
      @namespace = options[:namespace]
    end
    
    def read_config(filename)
      super
      @config.each_value do |route| 
        route[:render].sub! 'PLURAL/', "PLURAL/#{ @namespace }_"
        route[:url] = @namespace + route[:url] 
      end if @namespace
    end
    
  end
  
  register RestWithNamespace
  
end