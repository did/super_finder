require File.expand_path(File.dirname(__FILE__) + '/functional_spec_helper')

describe SuperFinder::GeneratorController do
  
  before(:all) do
    add_project_and_task_records
    
    SuperFinder::Initializer.run do |config|
      config.url = {
        :name_prefix  => 'admin',
        :action       => :edit 
      }
      config.scoper = { 
        :column => :account_id,
        :getter => :current_account
      }
      config.models = [
        { :klass => Project, :column => :title },
        { :klass => Task, :column => :name, :label => 'My tasks', :scope => false },
        { 
          :klass => Person, 
          :column => :nickname, 
          :label => Proc.new { |c| "My people" }, 
          :finder => Proc.new { |c| Person.all(:conditions => { :account_id => c.send(:current_account).id }) }
        }
      ]
    end
    
    # disable caching
    SuperFinder::CacheManager.instance.instance_eval do
      def fetch(klass, scoper = nil, &block)
        block.call
      end
    end
    
    @controller = SuperFinder::GeneratorController.new
    @controller.stubs(:url_for).returns('<url>')
  end
  
  it 'should return of records with an url, a label and a name for each entry' do
    map = @controller.send(:generate)
    
    map.should_not be_empty
    map.size.should == 3
    
    map["My people"].count.should == 1
    map["Fun project"].count.should == 2
    map["My tasks"].count.should == 3
  end
  
  it 'should generate a json output' do
    @controller.stubs(:url_for).returns('<url>')
    @controller.stubs(:view_paths).returns(nil)
    @controller.stubs(:default_template).returns(nil) 
    @controller.response = ActionController::TestResponse.new
        
    output = @controller.send(:index)
    output.should match /^SuperFinderResources = \{(.*)\}$/
  end
  
end