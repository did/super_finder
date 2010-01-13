require File.dirname(__FILE__) + '/../spec_helper'

describe 'Routes' do
  
  before do
    ActionController::Routing::Routes.draw do |map|
      map.resources :foos do |fu|
        fu.resources :bars
      end

      SuperFinder::Routes.draw(map)
      
      map.connect '/:controller/:action/:id'
    end  
  end
  
  it 'should add a custom route' do
    params_from(:get, '/super_finder_resources.js').should == { 
      :controller => 'super_finder/generator',
      :action => 'index' 
    }    
  end
  
  # from rspec-rails
  def params_from(method, path)
    ActionController::Routing::Routes.recognize_path(path, :method => method)
  end
  
end