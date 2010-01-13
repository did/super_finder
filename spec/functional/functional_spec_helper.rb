require File.join(File.dirname(__FILE__), '..', 'spec_helper')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define(:version => 1) do
  create_table :projects do |t|
    t.column :title, :string
    t.column :account_id, :integer
    t.column :created_at, :datetime      
    t.column :updated_at, :datetime
  end

  create_table :tasks do |t|
    t.column :name, :string
    t.column :created_at, :datetime      
    t.column :updated_at, :datetime
  end
  
  create_table :people do |t|
    t.column :nickname, :string
    t.column :account_id, :integer
    t.column :created_at, :datetime      
    t.column :updated_at, :datetime
  end
end

class Project < ActiveRecord::Base
end

class Task < ActiveRecord::Base
end

class Person < ActiveRecord::Base
end

class Account < ActiveRecord::Base
end

ApplicationController.class_eval do
  
  include Spec
  include Spec::Mocks
  include Spec::Mocks::Methods
  include Spec::Mocks::ExampleMethods
  include Spec::Rails::Mocks
  
  protected
  
  def current_account
    mock_model(Account, :id => 42) #("Account", :id => 42)    
  end
  
end


def add_project_and_task_records
  clean_records
  
  Project.create :title => 'Ruby on Rails', :account_id => 42
  Project.create :title => 'Liquid', :account_id => 42
  Project.create :title => 'CMS', :account_id => 43
  
  Task.create :name => 'build engines'
  Task.create :name => 'drink some beer'
  Task.create :name => 'sleep'
  
  Person.create :nickname => 'Bart', :account_id => 42
  Person.create :nickname => 'Homer', :account_id => 43
end

def clean_records
  Project.destroy_all
  Task.destroy_all
  Person.destroy_all
end

# def teardown_db
#   ActiveRecord::Base.connection.tables.each do |table|
#     ActiveRecord::Base.connection.drop_table(table)
#   end
# end