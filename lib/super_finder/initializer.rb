module SuperFinder
  
  class Initializer
   
    unloadable
   
    def self.run(&block)
      block.call(SuperFinder::Config.instance) if block_given?
      
      raise 'SuperFinder needs one or many models' if (SuperFinder::Config.instance.models || []).empty?
      
      self.apply
    end
    
    protected
    
    def self.apply
      # Cache Sweeper
      SuperFinder::CacheSweeper.instance # register the observer
      
      # Before filters
      unless (filters = SuperFinder::Config.instance.before_filters).empty?
        SuperFinder::GeneratorController.class_eval do
          before_filter SuperFinder::Config.instance.before_filters
        end
      end
    end
    
  end
  
end