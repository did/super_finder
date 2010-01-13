require File.expand_path(File.dirname(__FILE__) + '/unit_spec_helper')

describe SuperFinder::GeneratorController do
  
  before(:all) do
    class Project; end
    class Task; end
    class HelloWorld; end
        
    SuperFinder::CacheSweeper.stubs(:instance).returns(nil)    
    SuperFinder::Initializer.run do |config|
      config.url = {
        :name_prefix => 'admin',
        :action => :edit
      }
      config.before_filters = [:hello_world, :foo]
      config.models = [:foo, :bar]
    end        
  end
  
  before(:each) do
    @controller = SuperFinder::GeneratorController.new
    @controller.stubs(:url_for).returns('<url>')
    
    @entry = Project.new
    @entry.stubs(:id).returns(42)
    @entry.stubs(:attributes).returns({ 'title' => 'Simple one' })  
    
  end
  
  it 'should generate a label from a String or a Symbol' do
    @controller.send(:label_name, { :label => "test" }).should == 'test'
    @controller.send(:label_name, { :label => :hello }).should == 'hello'
  end
  
  it 'should generate a label from a Proc' do
    @controller.send(:label_name, { :label => Proc.new { |c| 'Test' } }).should == 'Test'
  end
  
  it 'should generate a label even without an option' do
    @controller.send(:label_name, { :klass => Project }).should == 'Fun project'
    @controller.send(:label_name, { :klass => Task }).should == 'Task'
    @controller.send(:label_name, { :klass => HelloWorld }).should == 'Helloworld'
  end
  
  it 'should return the value of an entry from the String or Symbol column option' do
    @controller.send(:column_value, @entry, { :klass => Project }).should_not == 'Simple one'
    @controller.send(:column_value, @entry, { :klass => Project, :column => :title }).should == 'Simple one'
    @controller.send(:column_value, @entry, { :klass => Project, :column => 'title' }).should == 'Simple one'
  end
  
  it 'should return the value of an entry from an Proc column option' do
    @entry.stubs(:foo).returns('Foo')    
    @controller.send(:column_value, @entry, { :klass => Project,  :column => Proc.new { |p| p.foo } }).should == 'Foo'
  end
  
  it 'should generate an url' do
    @controller.expects(:url_for).with({ :controller => 'admin/projects', :action => :edit, :id => 42 })
    @controller.send(:entry_url, @entry, { :klass => Project })
  end
  
  it 'should generate an url from an Hash option' do
    @controller.expects(:url_for).with({ :controller => 'projects', :action => :show, :id => 42 })
    @controller.send(:entry_url, @entry, { :klass => Project, :url => { :name_prefix => nil, :action => 'show' } })
  end
  
  it 'should generate an url from an Proc option' do
    @controller.send(:entry_url, @entry, { :klass => Project, :url => Proc.new { |c, p| '/index.html' } }).should == '/index.html'
  end
  
  it 'should have filters defined in the config instance' do
    @controller.class.send(:filter_chain).count.should == 2
    @controller.class.send(:filter_chain).collect(&:method).should == [:hello_world, :foo]
  end
  
end