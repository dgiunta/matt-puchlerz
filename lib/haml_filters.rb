module Haml
  module Filters
    
    module TextileInline  
      include Haml::Filters::Base
      include Haml::Filters::Textile
      
      def render(text)
        textiled = super(text)
        if textiled[0..2] == "<p>" then textiled = textiled[3..-1] end
        if textiled[-4..-1] == "</p>" then textiled = textiled[0..-5] end
        textiled
      end
    end
    
  end
end