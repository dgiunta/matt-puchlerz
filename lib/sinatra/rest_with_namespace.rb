module Sinatra
  
  module RestWithNamespace
    
    include REST
   
    def parse_args(model_class, options)
      super
      @namespace = options[:namespace]
    end
    
    def read_config(filename)
      super
      @config.each_value { |hash| hash[:url] = @namespace + hash[:url] }
    end
    
  end
  
  register RestWithNamespace
  
end