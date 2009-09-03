namespace :moritz do

  desc "Initialize Rails"
  task :init do
    require File.dirname(__FILE__) + '/../../../../config/boot'
    require "#{RAILS_ROOT}/config/environment"
    require 'rails_generator'
    require 'rails_generator/scripts/generate'
  end
  
  desc "Install Moritz Stefaner's Relation Browser"
  task :install => :init do
    model, controller = ENV['model'], ENV['controller']
    # generate a proxy model
    args = ['moritz', model]
    Rails::Generator::Scripts::Generate.new.run(args)
    # generate a proxy controller, if not exist
    unless File.exist?("app/controller/#{controller}_controller.rb")
      args = ['controller', controller]
      Rails::Generator::Scripts::Generate.new.run(args)
    end
    # insert "relation_browser :#{model}" as 2nd line of controller
    src = File.join(%w(app controllers) << "#{controller}_controller.rb")
    system("sed -i '2i\\  relation_browser :#{model}' #{src}")
    # copy views
    src = File.join(%w(vendor plugins moritz resources views root.rxml))
    FileUtils.cp(src, File.join(%w(app views) << controller))
    src = File.join(%w(vendor plugins moritz resources views children.rxml))
    FileUtils.cp(src, File.join(%w(app views) << controller))
    # copy flash
    src = File.join(%w(vendor plugins moritz resources RelationBrowser_v1.2 generic RelationBrowser.swf))
    FileUtils.cp(src, File.join(%w(public)))
    # rename model.rb_ to model.rb
    src = File.join(%w(app models) << "#{model}.rb_")
    dst = File.join(%w(app models) << "#{model}.rb")
    FileUtils.mv(src, dst)
    # output message, where to browse to
    puts "done. now browse to ..."
    puts "\t/RelationBrowser.swf?dataSource=/#{controller}/root/<model>_<id>"
  end

  desc "Uninstall Moritz Stefaner's Relation Browser"
  task :uninstall => :init do
    model, controller = ENV['model'], ENV['controller']
    # delete model
    src = File.join(%w(app models) << "#{model}.rb")
    puts "removing: #{src}"
    FileUtils.rm(src)
    # remove 2nd line from controller
    src = File.join(%w(app controllers) << "#{controller}_controller.rb")
    puts "editing: #{src}"
    system("sed -i '2D' #{src}")
    # delete views
    src = File.join(%w(app views) << controller << 'root.rxml')
    puts "removing: #{src}"
    FileUtils.rm(src)
    src = File.join(%w(app views) << controller << 'children.rxml')
    puts "removing: #{src}"
    FileUtils.rm(src)
    # delete falsh
    src = File.join(%w(public RelationBrowser.swf))
    puts "removing: #{src}"
    FileUtils.rm(src)
  end

end


