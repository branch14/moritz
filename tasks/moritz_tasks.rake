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
    args = %w(moritz #{model})
    Rails::Generator::Scripts::Generate.new.run(args)
    # generate a proxy controller, if not exist
    unless File.exist?("app/controller/#{controller}_controller.rb")
      args = %w(controller #{controller})
      Rails::Generator::Scripts::Generate.new.run(args)
    end
    # insert "relation_browser :#{model}" as 2nd line of controller
    path = File.join(%w(app controller #{controller}_controller.rb))
    FileUtils.sh("sed -i '2i\\  relation_browser :#{model}' #{path}")
    # copy views
    path = File.join(%w(vendor plugins moritz resources views root.rxml))
    FileUtils.cp(path, File.join(%w(app views #{controller})))
    path = File.join(%w(vendor plugins moritz resources views children.rxml))
    FileUtils.cp(path, File.join(%w(app views #{controller})))
    # copy flash
    path = File.join(%w(vendor plugins moritz resources RelationBrowser_v1.2 generic RelationBrowser.swf))
    FileUtils.cp(path, File.join(%w(public)))
    # output message, where to browse to
    puts "done. now browse to ..."
    puts "\t/RelationBrowser.swf?dataSource=/#{controller}/root/<model>_<id>"
  end

  # desc "Uninstall Moritz Stefaner's Relation Browser"
  # task :uninstall do
  # end

end


