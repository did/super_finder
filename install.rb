require 'fileutils'

RAILS_ROOT = File.expand_path( File.join(File.dirname(__FILE__), '../../../') )

['images', 'stylesheets', 'javascripts'].each do |folder|
  unless FileTest.exist? File.join(RAILS_ROOT, 'public', folder, 'super_finder')
    FileUtils.mkdir( File.join(RAILS_ROOT, 'public', folder, 'super_finder') )
  end
  
  FileUtils.cp(
    Dir[File.join(File.dirname(__FILE__), 'assets', folder, '*')],
    File.join(RAILS_ROOT, 'public', folder, 'super_finder'),
    :verbose => true
  )
end
