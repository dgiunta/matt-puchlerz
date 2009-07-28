require 'datamapper'
require 'active_support/core_ext/blank'

module MattPuchlerz
  class Work
    
    include DataMapper::Resource
    
    IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    
    property :id,          Serial
    property :description, Text
    property :slug,        String
    property :title,       String
    
    def images
      if slug.blank?
        return []
      elsif not @images.blank?
        return @images
      end
      
      path = File.expand_path( File.join( Sinatra::Application.public, IMAGE_DIR, attribute_get(:slug), "*.{gif,jpg,png}" ) )
      @images = Dir.glob(path).map { |i| File.basename(i) }.sort
    end
    
    def slug=(slug)
      attribute_set :slug, slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
    
    def viewable?
      not slug.blank? and not title.blank? and not description.blank? and not images.blank?
    end
        
  end
end