module MattPuchlerz
  class Work
    
    attr_accessor :description, :images, :title
    
    def initialize
      @images = []
    end
        
    def viewable?
      !title.blank? and !description.blank? and !images.blank?
    end
    
  end
end