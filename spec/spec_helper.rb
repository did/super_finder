$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'mocha'

gem 'actionpack'
gem 'activerecord', '>= 1.15.4.7794'
require 'action_controller'
require 'action_controller/test_process.rb'
require 'active_support'
require 'action_pack'
require 'action_view'
require 'active_record'
require 'active_record/observer'

require 'spec'
require 'spec/mocks'
require 'spec/mocks/mock.rb'
require 'spec/rails/mocks.rb'
require 'spec/autorun'

I18n.load_path << Dir[File.join(File.dirname(__FILE__), 'assets', 'locales', '*.{rb,yml}') ] 
I18n.default_locale = :en

class ApplicationController < ActionController::Base
end

require 'super_finder'


Spec::Runner.configure do |config|
  config.mock_with :mocha
end

include ActionController::UrlWriter

