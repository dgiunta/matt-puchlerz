module MattPuchlerz
  
  class Work
    
    attr_accessor :description, :images, :slug, :title
    
    def initialize(options = {})      
      @description = options[:description].to_s
      @images      = options[:images].to_a
      @title       = options[:title].to_s
    end
    
    def slug=(slug)
      @slug = slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
        
    def viewable?
      !slug.blank? and !title.blank? and !description.blank? and !images.blank?
    end
    
  end
  
end