require 'fileutils'

['images', 'stylesheets', 'javascripts'].each do |folder|
  if folder == 'images'
    unless FileTest.exist? File.join(RAILS_ROOT, 'public', 'images', 'super_finder')
      FileUtils.mkdir( File.join(RAILS_ROOT, 'public', 'images', 'super_finder') )
    end
  end
  
  FileUtils.cp(
    Dir[File.join(File.dirname(__FILE__), 'assets', folder, '*')],
    File.join(RAILS_ROOT, 'public', folder, folder == 'images' ? 'super_finder' : nil)
  )
end
