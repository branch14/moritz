class MoritzGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    super
  end

  def manifest
    record do |m|
      path = File.join(*(%w(app models) + class_path))
      model = File.join(*(%w(app models) + class_path + ["#{file_name}.rb"]))
      m.directory(path)
      m.template('model.rb', model)
    end
  end

  def map_all_models_with_associations
    #...
  end

  protected

  def banner
    "Usage: #{$0} moritz ModelName"
  end
  
end
