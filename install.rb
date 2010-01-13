require 'fileutils'

RAILS_ROOT = File.expand_path( File.join(File.dirname(__FILE__), '../../../') )

['images', 'stylesheets', 'javascripts'].each do |folder|
  if folder == 'images'
  unless FileTest.exist? File.join(RAILS_ROOT, 'public', 'images', 'super_finder')
    FileUtils.mkdir( File.join(RAILS_ROOT, 'public', 'images', 'super_finder') )
  end
  
  FileUtils.cp(
    Dir[File.join(File.dirname(__FILE__), 'assets', folder, '*')],
    File.join(RAILS_ROOT, 'public', folder, folder == 'images' ? 'super_finder' : nil)
  )
end
