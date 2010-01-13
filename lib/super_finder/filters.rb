# Monkey patch to enable filters even in development environment.
module SuperFinder
  
  module Filters
   
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
       
      def enable_super_finder_filters
        class_eval <<-EOV
          include SuperFinder::Filters::InstanceMethods
          before_filter :apply_superfinder_filters
        EOV
      end

    end
    
    module InstanceMethods
      
      def apply_superfinder_filters
        (SuperFinder::Config.instance.before_filters || []).each do |filter|
          return false if self.send(filter.to_sym) == false
        end
      end
      
    end
    
  end
  
end