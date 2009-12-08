# Dependent on "action_pack" in the $LOAD_PATH
require 'action_controller/vendor/html-scanner'

module Sinatra
  
  module HtmlSanitizer
    
    def strip_tags html
      @sanitizer ||= HTML::FullSanitizer.new
      @sanitizer.sanitize html
    end
    
  end
  
  helpers HtmlSanitizer
  
end