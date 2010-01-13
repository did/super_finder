module SuperFinder
  
  module Routes
    
    def self.draw(map)
      map.super_finder_resources '/super_finder_resources.js', :controller => 'super_finder/generator', :action => 'index'
    end
  end
  
end