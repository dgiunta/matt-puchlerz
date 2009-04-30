module MattPuchlerz
  
  class Work
    
    IMAGE_DIR = File.join('images', 'works')
    
    attr_reader :description, :slug, :title
    
    def initialize(options = {})
      @images = []
      self.description = options[:description].to_s
      self.slug        = options[:slug]
      self.title       = options[:title].to_s
    end
    
    def description=(description)
      @description = description.to_s
    end
    
    def images
      return @images if slug.blank? or !@images.blank?
      
      path = File.expand_path( File.join( Sinatra::Application.public, IMAGE_DIR, slug, "*.{gif,jpg,png}" ) )
      @images = Dir.glob(path).map { |i| File.basename(i) }.sort
    end
        
    def slug=(slug)
      @slug = slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
    
    def title=(title)
      @title = title.to_s
    end
        
    def viewable?
      !slug.blank? and !title.blank? and !description.blank? and !images.blank?
    end
    
  end
  
end