module MattPuchlerz
  
  class Work
    
    attr_accessor :description, :images, :title
    
    def initialize(options = {})      
      @description = options[:description].to_s
      @images      = options[:images].to_a
      @title       = options[:title].to_s
    end
        
    def viewable?
      !title.blank? and !description.blank? and !images.blank?
    end
    
  end
  
end