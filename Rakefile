require 'rake'
require 'rubygems'
require 'spec/rake/spectask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "super_finder"
    gem.summary = %Q{TextMate's "cmd-T" functionality in a web app}
    gem.description = %Q{TextMate's "cmd-T" functionality in a web app}
    gem.email = "didier@nocoffee.fr"
    gem.homepage = "http://github.com/did/super_finder"
    gem.authors = ["Didier Lafforgue"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

desc 'Test the super_finder plugin.'
Spec::Rake::SpecTask.new('spec:unit') do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/unit/**/*_spec.rb']
end

Spec::Rake::SpecTask.new('spec:functionals') do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/functional/**/*_spec.rb']
end

task :spec => ['spec:unit', 'spec:functionals']

desc 'Default: run rspec tests.'
task :default => :spec

desc 'Generate documentation for the super_finder plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SuperFinder'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
