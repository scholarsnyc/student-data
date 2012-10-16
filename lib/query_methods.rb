module QueryMethods

  def self.patch(*models)
    models.each do |model|
      unless model.respond_to?(:has_been_patched?)
        model.properties.each do |prop|
          
          # Add search methods
          model.define_singleton_method(prop.name) { |query| all(prop => query) }
          
          # Add descriptive methods
          model.define_singleton_method(prop.name.to_s.pluralize.to_sym) do
            all(order: [ prop.name.asc ]).map { |n| n.method(prop.name).call }.uniq!.delete_if { |n| n.nil?}
          end
          
          # Add a helper method to easily map properties
          
          # Tagged the class as patched so that QueryMethods passes it by next time around
          model.define_singleton_method(:has_been_patched?) { true }
        end
      end
    end
  end

end