class MoritzGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      m.directory File.join(*%w(app models), class_path)
      m.template 'model.rb', File.join(*%w(app models), class_path, "#{filename}.rb")
    end
  end

  protected

  def banner
    "Usage: #{$0} moritz ModelName"
  end
  
end
