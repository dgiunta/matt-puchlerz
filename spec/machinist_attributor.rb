require 'machinist'
require 'machinist/blueprints'

module Machinist
  
  module AttributorExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def make(*args, &block)
        lathe = Lathe.run(Machinist::AttributorAdapter, self.new, *args)
        lathe.object.save
        lathe.object(&block)
      end
    end
  end
  
  class AttributorAdapter
    def self.has_association?(object, attribute)
      false
    end
  end
  
end

class Object
  include Machinist::Blueprints
  include Machinist::AttributorExtensions
end
