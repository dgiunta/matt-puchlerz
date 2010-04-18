require 'active_support/core_ext/object/blank'
require 'rack/utils'

module MattPuchlerz
  class Work
    
    attr_accessor :description, :slug, :title
    
    IMAGE_DIR = File.join('images', 'works') unless defined?(IMAGE_DIR)
    
    @@instances = []
  
    # 
    # Class methods
    # 
    
    def self.all
      @@instances
    end
    
    def self.create attributes = {}
      instance = new attributes
      instance.save
      instance
    end
    
    def self.first conditions = {}
      if conditions.empty?
        @@instances.first
      else
        @@instances.detect { |i| i.slug == conditions[:slug] }
      end
    end
    
    def self.viewable
      all.select { |work| work.viewable? }
    end
    
    # 
    # Instance methods
    # 
    
    def initialize attributes = {}
      attributes.each_pair { |key, val| self.send "#{ key }=", val }
    end
    
    def image_thumbnail
      all_images.detect { |path| path =~ /\/_thumb./ }
    end
    
    def images
      # Get rid of any images that begin with an underscore
      all_images.reject { |path| path =~ /\/_/ }
    end
    
    def next_item
      next_viewable_item
    end
    
    def previous_item
      next_viewable_item @@instances.reverse
    end
    
    def save
      @@instances << self
      true
    end
    
    def slug= slug
      @slug = slug.to_s.strip.downcase.gsub(/[^\w\-\ ]/, '').gsub(' ', '_')
    end
    
    def viewable?
      not slug.blank? and 
      not title.blank? and 
      not description.blank? and 
      not images.blank? and 
      not image_thumbnail.blank?
    end
    
    private
    
    def all_images
      return [] if slug.blank?
      return @all_images unless @all_images.blank?
      
      @all_images = self.class.find_images self.slug
      @all_images = self.class.convert_to_relative_paths @all_images
      @all_images.sort!
    end
    
    def next_viewable_item instances = nil
      instances ||= @@instances
      start = instances.index(self) + 1
      instances[start..-1].detect { |i| i.viewable? }
    end
    
    # Find images that are within /public/images/works/slug-name/
    def self.find_images(slug)
      Dir.glob File.expand_path( File.join( 
        Sinatra::Application.public, 
        IMAGE_DIR, 
        slug, 
        "*.{gif,jpg,png}" 
      ))
    end
    
    # Make the image paths relative from the public directory
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