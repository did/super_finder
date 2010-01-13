require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe SuperFinder::Initializer do
  
  before(:each) do
    SuperFinder::Config.instance.reset_attributes
  end
  
  it 'should update config settings' do
    SuperFinder::Initializer.stubs(:apply).returns(true)
    
    SuperFinder::Initializer.run do |config|
      config.url = { :name_prefix => 'admin', :action => :edit }
      config.models = ['foo', 'bar']
    end
    
    SuperFinder::Config.instance.url[:name_prefix].should == 'admin'
    SuperFinder::Config.instance.url[:action].should == :edit
  end
  
  it 'should need models' do
    lambda {
      SuperFinder::Initializer.run
    }.should raise_error
  end
  
  it 'should apply default config' do
    SuperFinder::Initializer.expects(:apply).returns(true)
    SuperFinder::Initializer.run do |config|
      config.models = ['foo', 'bar']
    end
  end
  
  it 'should apply new config once they all have been set' do
    SuperFinder::Initializer.expects(:apply).returns(true)
    
    SuperFinder::Initializer.run do |config|
      config.name_prefix = 'admin'
      config.default_action = :edit
      config.models = ['foo', 'bar']
    end
  end
  
end