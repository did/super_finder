require 'rake'
require 'spec/rake/spectask'
require 'rake/rdoctask'

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
