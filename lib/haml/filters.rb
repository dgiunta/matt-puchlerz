require 'haml'

module Haml
  module Filters
    
    module TextileInline
      include Base
      lazy_require 'redcloth'
      
      def render(text)
        textiled = Textile.render(text)
        textiled = textiled[3..-1] if textiled[0..2] == "<p>"
        textiled = textiled[0..-5] if textiled[-4..-1] == "</p>"
        textiled
      end
    end
    
  end
end