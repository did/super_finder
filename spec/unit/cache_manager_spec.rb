require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe SuperFinder::CacheManager do
  
  before(:each) do
    class Project; end
  end
  
  it 'should generate a key' do
    key = SuperFinder::CacheManager.instance.key(Project)
    key.should match /superfinder_all_projects_[0-9]*/
    
    SuperFinder::CacheManager.instance.key(Project).should == key
  end
  
  it 'should generate a key depending on a scoper' do
    @instance = Object.new
    @instance.stubs(:id).returns(42)
    
    key = SuperFinder::CacheManager.instance.key(Project, @instance)
    key.should match /superfinder_42_projects_[0-9]*/
    
    SuperFinder::CacheManager.instance.key(Project, @instance).should == key
  end
  
  it 'should generate a key depending on a scoper by passing its id' do
    key = SuperFinder::CacheManager.instance.key(Project, 7)
    key.should match /superfinder_7_projects_[0-9]*/
    
    SuperFinder::CacheManager.instance.key(Project, 7).should == key
  end
  
  it 'should refresh a key' do
    key = SuperFinder::CacheManager.instance.key(Project)
    
    SuperFinder::CacheManager.instance.refresh!(Project)
    
    SuperFinder::CacheManager.instance.key(Project, @instance).should != key
  end
  
end