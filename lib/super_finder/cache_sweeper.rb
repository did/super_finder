module SuperFinder
  
  class CacheSweeper < ActiveRecord::Observer
    
    unloadable
    
    def after_create(record)
      refresh_cache!(record)
    end
    
    def after_update(record)
      refresh_cache!(record)
    end
    
    def after_destroy(record)
      refresh_cache!(record)
    end
    
    def refresh_cache!(record)
      models, scoper = SuperFinder::Config.instance.models, SuperFinder::Config.instance.scoper
      
      options = models.find { |m| m[:klass].name == record.class.name } # do not rely on class in dev mode
            
      scope_id = nil
      
      if options[:scope].nil?
        if scoper && scoper[:column] # looking for a global scope
          scope_id = record.attributes[scoper[:column].to_s]
        end
      end
      
      SuperFinder::CacheManager.instance.refresh!(record.class, scope_id)
    end
    
    def observed_classes
      SuperFinder::Config.instance.models.map { |m| eval(m[:klass].name) }
    end
    
  end
  
end