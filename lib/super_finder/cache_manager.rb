module SuperFinder
  
  class CacheManager
    
    include Singleton
    
    @@caching_keys = {}
    
    def fetch(klass, scoper = nil, &block)
      ::Rails.cache.fetch(self.key(klass, scoper), &block)
    end
    
    def key(klass, scoper = nil)
      key = internal_key(klass, scoper)
      
      @@caching_keys[key] ||= Time.now

      "superfinder_#{key}_#{@@caching_keys[key].to_i}"
    end
    
    def refresh!(klass, scoper = nil)
      @@caching_keys[internal_key(klass, scoper)] = nil
    end
    
    protected
    
    def internal_key(klass, scoper = nil)
      scope_id = (if scoper 
        scoper.is_a?(Integer) ? scoper : scoper.id
      else
        :all
      end)      
      "#{scope_id}_#{klass.name.tableize}"
    end

  end
  
end