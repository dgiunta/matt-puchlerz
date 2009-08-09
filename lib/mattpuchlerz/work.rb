require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'dm-is-list'
require 'active_support/core_ext/blank'
require 'rack/utils'

module MattPuchlerz
  class Work
    
    include DataMapper::Resource
    include DataMapper::Transaction::Resource
    
    IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    
    property :id,          Serial
    property :description, Text
    property :slug,        Slug
    property :title,       String
    
    is :list
    
    def images
      if slug.blank?
        return []
      elsif not @images.blank?
        return @images
      end
      
      pattern = File.expand_path( File.join( 
        Sinatra::Application.public, 
        IMAGE_DIR, 
        attribute_get(:slug), 
        "*.{gif,jpg,png}" 
      ))
      
      @images = Dir.glob(pattern).map do |path| 
        path.sub! Sinatra::Application.public, ''
        path = Rack::Utils.escape(path)
        path.gsub! '%2F', '/'
      end.sort
    end
    
    def slug=(slug)
      attribute_set :slug, slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
    
    def viewable?
      not slug.blank? and not title.blank? and not description.blank? and not images.blank?
    end
    
    def self.viewable
      all.select { |work| work.viewable? }
    end
        
  end
end