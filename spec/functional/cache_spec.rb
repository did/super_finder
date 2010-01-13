require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

describe SuperFinder::CacheSweeper do
  
  before(:all) do
    add_project_and_task_records
    
    SuperFinder::Initializer.run do |config|
      config.name_prefix = 'admin'
      config.default_action = :edit
      config.scoper = { 
        :column => :account_id
      }
      config.models = [
        { :klass => Project },
        { :klass => Task, :scope => false }
      ]
    end
  end
  
  it 'should refresh cache if a record is added' do
    SuperFinder::CacheSweeper.instance.expects(:refresh_cache!).returns(true)
  
    Project.create :title => 'Hello world !'
  end
  
  it 'should refresh cache if a record is updated' do
    SuperFinder::CacheSweeper.instance.expects(:refresh_cache!).returns(true)
  
    Project.first.update_attribute :title, 'new title'
  end
  
  it 'should refresh cache if a record is destroyed' do
    SuperFinder::CacheSweeper.instance.expects(:refresh_cache!).returns(true)
  
    Project.first.destroy
  end
  
  it 'should refresh cache based on a scope id' do
    SuperFinder::CacheManager.instance.expects(:refresh!).with(Project, 42).returns(true)
    
    Project.create :title => 'Hello world !', :account_id => 42
  end
  
end