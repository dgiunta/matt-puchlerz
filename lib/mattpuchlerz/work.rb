require 'dm-core'
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
    
    # Set default order
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
      not slug.blank? and 
      not title.blank? and 
      not description.blank? and 
      not images.blank? and 
      not image_thumbnail.blank?
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
      
      @all_images = self.class.find_images self.slug
      @all_images = self.class.convert_to_relative_paths @all_images
      @all_images.sort!
    end
    
    # Find images that are within /public/images/works/slug-name/
    # 
    def self.find_images(slug)
      Dir.glob File.expand_path( File.join( 
        Sinatra::Application.public, 
        IMAGE_DIR, 
        slug, 
        "*.{gif,jpg,png}" 
      ))
    end
    
    # Make the image paths relative from the public directory
    # 
    def self.convert_to_relative_paths(paths)
      paths.map do |path| 
        path = path.sub Sinatra::Application.public, ''
        path = Rack::Utils.escape(path)
        path = path.gsub '%2F', '/'
        path
      end      
    end
        
  end
end