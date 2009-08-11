require 'dm-core'
require 'dm-migrations'
require 'dm-types'
require 'dm-is-list'
require 'active_support/core_ext/blank'
require 'rack/utils'

module MattPuchlerz
  class Work
    
    include DataMapper::Resource
    
    # The dm-is-list gem utilizes transactions, and 
    # for some reason, the transaction code isn't 
    # being included into Resource automatically.
    include DataMapper::Transaction::Resource
    
    IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    
    property :id,          Serial
    property :description, Text
    property :slug,        Slug
    property :title,       String
    
    is :list
    
    # default order
    default_scope(:default).update :order => [ :position ]
    
    def image_thumbnail
      all_images.detect { |path| path =~ /\/_thumb./ }
    end
    
    def images
      # Get rid of any images that begin with an underscore
      all_images.reject { |path| path =~ /\/_/ }
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
    
    private
    
    def all_images
      if slug.blank?
        return []
      elsif not @all_images.blank?
        return @all_images
      end
      
      # Find images that are within /public/images/works/slug-name/
      pattern = File.expand_path( File.join( 
        Sinatra::Application.public, 
        IMAGE_DIR, 
        attribute_get(:slug), 
        "*.{gif,jpg,png}" 
      ))
      @all_images = Dir.glob(pattern)
      
      # Make the image paths relative from the public directory
      @all_images.map do |path| 
        path.sub! Sinatra::Application.public, ''
        path = Rack::Utils.escape(path)
        path.gsub! '%2F', '/'
      end.sort
    end
        
  end
end