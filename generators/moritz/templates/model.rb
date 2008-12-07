class <%= class_name %>
    
  attr_accessor :obj_class
  attr_accessor :obj_id
  attr_accessor :object
  
  # --- methods
  
  def initialize(model_id)
    model, id = model_id.split('_')
    self.obj_class = Kernel.const_get(model)
    self.obj_id = id.to_i
  end
  
  def obj
    object ||= Kernel.const_get(self.obj_class).find(self.obj_id)
  end
  
  def id
    "#{obj.class.name}_#{obj.id}"
  end
  
  def name
    return obj.display_name if obj.class.public_method_defined? :display_name
    return obj.name if obj.class.column_names.include? :name
    return "#{id}"
  end
  
  # --- nested set stuff 
  
  def full_set # array of itself and all children and nested children (this plus descendants)
    rv = []
    rv << self
    rv += self.children
    rv
  end
  
  def children # array of all children and nested children (all descendants) 
    list = self.direct_children
    rv = []
    rv += list
    list.each do |i|
      rv += i.direct_children
    end
    rv
  end
  
##   def direct_children # array of immediate children
##     rv = []
##     obj.class.reflect_on_all_associations.each do |a|
##       m, n = a.macro, a.name
##       rv << obj.send(n) if (m==:belongs_to && obj.send(n))
##       rv += obj.send(n) if( m==:has_many || m==:has_and_belongs_to_many)
##     end
##     rv.collect { |i| self.class.new("#{i.class.name}_#{i.id}") }
##   end

  def association_methods
    case obj
      <%
        files = Dir.glob("app/models/**/*.rb")
        files += Dir.glob("vendor/plugins/**/app/models/*.rb") if @options.plugins_models 
        files.each do |file|
          model_name = File.basename(file, '.rb').camelize
      %>
          when <%= model_name %>
      <%
          klass = Kernel.const_get(model_name)
          assocs = klass.reflect_on_all_associations.map(&:name)
      %>
          <%= assocs.inspect %>
      <% end %>
    end
  end

  def direct_children # array of immediate children
    rv = []
    association_methods.each do |m|
      r = obj.send(m)
      rv += r.is_a?(Array) ? r : [r]
    end
    rv.collect { |i| self.class.new("#{i.class.name}_#{i.id}") }
  end
  
end
