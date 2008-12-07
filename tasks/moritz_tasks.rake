
desc 'copy the required file to public/swf'
task :moritz_install_files do

  cwd = File.dirname(__FILE__)

  FileUtils.mkdir_p(File.join(cwd, *%w(public swf)))
  FileUtils.cp(File.join(cwd, *%w(public swf RelationBrowser.swf)), File.join(cwd, *w%(public swf)))
  
end
