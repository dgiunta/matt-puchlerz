require 'datamapper'

module MattPuchlerz
  
  class Work
    
    include DataMapper::Resource
    
    IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    
    property :id,          Serial
    property :slug,        String
    property :title,       String
    property :description, String
    
    def images
      if slug.nil?
        return []
      elsif not @images.nil?
        return @images
      end
      
      path = File.expand_path( File.join( Sinatra::Application.public, IMAGE_DIR, attribute_get(:slug), "*.{gif,jpg,png}" ) )
      @images = Dir.glob(path).map { |i| File.basename(i) }.sort
    end
    
    def slug=(slug)
      attribute_set :slug, slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
    
    def viewable?
      false
    end
    
    # IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    # 
    # attr_reader :description, :slug, :title
    # 
    # def initialize(options = {})
    #   @images = []
    #   self.description = options[:description].to_s
    #   self.slug        = options[:slug]
    #   self.title       = options[:title].to_s
    # end
    # 
    # def description=(description)
    #   @description = description.to_s
    # end
    # 
    # def images
    #   return @images if slug.blank? or !@images.blank?
    #   
    #   path = File.expand_path( File.join( Sinatra::Application.public, IMAGE_DIR, slug, "*.{gif,jpg,png}" ) )
    #   @images = Dir.glob(path).map { |i| File.basename(i) }.sort
    # end
    #     
    # def slug=(slug)
    #   @slug = slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    # end
    # 
    # def title=(title)
    #   @title = title.to_s
    # end
    #     
    # def viewable?
    #   !slug.blank? and !title.blank? and !description.blank? and !images.blank?
    # end
    
  end
  
end