module MerbSettings
  module Adapter
    module DataMapper
      
      def self.included(base)
        # Ensure base is a resource
        base.send(:include, ::DataMapper::Resource) unless ::DataMapper::Resource > base
        
        # Setup the properties for the model
        set_model_class_decs!(base)
#        base.send(:include, Map)
#        base.send(:include, InstanceMethods )
        base.send(:include, Common)
        
        Settings[:single_resource] ||= base.name.snake_case.to_sym
        Settings[:plural_resource] ||= Settings[:single_resource].to_s.pluralize.to_sym
          
        #Settings[:user] = base
      end
      
#      module InstanceMethods
#      end # InstanceMethods

#      private 
#      def self.set_model_class_decs!(base)
#      end # self.set_model_class_decs!
      
      module DefaultModelSetup
        
        def self.included(base)
          base.class_eval do
            property :id, Integer, :serial   => true
            property :name, String
            property :value, Yaml
            property :created_at, DateTime
            property :updated_at, DateTime
          end
        end
      end # DefaultModelSetup     
      
    end # DataMapper
  end # Adapter
end
