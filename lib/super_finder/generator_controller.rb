class SuperFinder::GeneratorController < ApplicationController
  
  unloadable
  
  # enable_super_finder_filters # hack for dev env
  
  def index
    render :text => "SuperFinderResources = #{self.generate.to_json}"
  end
  
  protected
  
  def reloaded_entry_klass(klass)
    Rails.env.development? ? eval(klass.name) : klass
  rescue
    klass
  end
  
  def collect_entries_for(options)
    SuperFinder::CacheManager.instance.fetch(options[:klass], get_scoper(options)) do
      entries = (case options[:finder]
      when Proc
        options[:finder].call(self)
      else
        scoper = SuperFinder::Config.instance.scoper
      
        conditions = {}
      
        if options[:scope].nil?
          if scoper && scoper[:column] # looking for a global scope
            conditions = { scoper[:column] => self.send(scoper[:getter]).id }
          end
        end
      
        reloaded_entry_klass(options[:klass]).all(:conditions => conditions)
      end)
    
      entries.map do |entry|
        {
          :value => column_value(entry, options),
          :url => entry_url(entry, options)
        }
      end
    end
  end
  
  def get_scoper(options)
    self.send(SuperFinder::Config.instance.scoper[:getter].to_sym) rescue nil
  end
  
  def label_name(options)
    case options[:label]
    when String, Symbol then options[:label].to_s
    when Proc then options[:label].call(self)
    else
      name = options[:klass].name
      I18n.t(name.demodulize.underscore, :scope => [:activerecord, :models], :default => name.humanize)
    end
  end
  
  def column_value(entry, options)
    case options[:column]
    when String, Symbol then entry.attributes[options[:column].to_s]
    when Proc then options[:column].call(entry).to_s
    else
      '[Superfinder] Column is missing'
    end
  end
  
  def entry_url(entry, options) 
    url = options[:url]
    case url
    when Hash, nil
      url = (SuperFinder::Config.instance.url || {}).merge(url || {})
      resource_name = entry.class.name.pluralize.underscore
      
      url_for({
        :controller => File.join(['/', url[:name_prefix], resource_name].compact),
        :action     => url[:action].to_sym ,
        :id         => entry.id
      })
    when Proc then url.call(self, entry)
    end
  end
    
  def generate
    map = {}
    SuperFinder::Config.instance.models.each do |options|
      map[label_name(options)] = self.collect_entries_for(options)
    end
    map
  end
  
end
