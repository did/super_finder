$:.unshift File.expand_path(File.dirname(__FILE__))

require 'super_finder/routes'
require 'super_finder/config'
require 'super_finder/initializer'
require 'super_finder/cache_manager'
require 'super_finder/cache_sweeper'
require 'super_finder/helper'
require 'super_finder/filters'

ActionView::Base.send :include, SuperFinder::Helper

# ActionController::Base.class_eval { include SuperFinder::Filters } # dirty hack for dev env

require 'super_finder/generator_controller'


