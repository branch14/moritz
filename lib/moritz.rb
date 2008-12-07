# Moritz

module Moritz
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  class Config

    attr_reader :model
    attr_reader :model_id
    
    def initialize(model_id)
      @model_id = model_id
      @model = model_id.to_s.camelize.constantize
    end
    
    def model_name
      @model_id.to_s
    end

  end
  
  module ClassMethods
    
    def relation_browser(model_id = nil)
      # converts Foo::BarController to 'bar' and FooBarsController to 'foo_bar'
      # and AddressController to 'address' 
      model_id = self.to_s.split('::').last.sub(/Controller$/, '').pluralize.singularize.underscore unless model_id
      @relation_browser_config = RelationBrowser::Config.new(model_id)
      #if @relation_browser_config.model.extended_by.include?(ActiveRecord::Acts::NestedSet::ClassMethods) 
      include RelationBrowser::InstanceMethods
      #end 
    end
    
    # Make the @acts_as_exportable_config class variable easily
    # accessable from the instance methods.
    def relation_browser_config
      @relation_browser_config || self.superclass.instance_variable_get('@relation_browser_config')
    end

  end

  module InstanceMethods

    def initialize
      # @model = self.controller_name.pluralize.singularize.camelize.constantize
      @model = self.class.relation_browser_config.model
      @templates_path = File.join(RAILS_ROOT, *%w(vendor plugins moritz views))
    end
    
    # def relationships
    #   render :file => File.join(@templates_path, "relationships.rhtml"), :locals => {:controller_name => self.controller_name}
    # end
    
    def root
      @root = @model.new(params[:id])
      render :file => File.join(@templates_path, "root.rxml")
    end
    
    def children
      @object = @model.new(params[:id])
      render :file => File.join(@templates_path, "children.rxml")
    end

  end

end
