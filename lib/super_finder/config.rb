require 'singleton'

module SuperFinder
  
  class Config
    
    include Singleton
    
    @@default_options = {
      :url              => {
        :name_prefix      => nil,
        :action           => :show
      },
      :models           => [],
      :scoper           => {
        :column => nil,
        :getter => nil
      },
      :before_filters   => []
    }
    
    def attributes
      @attributes ||= @@default_options.clone # only called once 
    end
    
    def reset_attributes
      @attributes = nil
    end
    
    def method_missing(method, *args)
      if method.to_s.ends_with?('=')
        attributes[method.to_s[0..-2].to_sym] = args.first
      else
        attributes[method]
      end
    end
    
    def to_s
      attributes.inspect
    end
    
  end
  
end
  