require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe SuperFinder::Config do
  
  before(:each) do
    SuperFinder::Config.instance.reset_attributes
  end
  
  it 'should have default values' do
    SuperFinder::Config.instance.url.should == { :name_prefix => nil, :action => :show }
    SuperFinder::Config.instance.models.should be_empty
    SuperFinder::Config.instance.scoper.should == { :column => nil, :getter => nil }
    SuperFinder::Config.instance.before_filters.should be_empty
  end
  
  it 'should set custom values' do
    SuperFinder::Config.instance.url = { :name_prefix => 'admin', :action => :edit }
    SuperFinder::Config.instance.url.should == { :name_prefix => 'admin', :action => :edit }
    
    SuperFinder::Config.instance.before_filters = ['require_account', 'set_scoper']
    SuperFinder::Config.instance.before_filters.should == ['require_account', 'set_scoper']
  end
  
end