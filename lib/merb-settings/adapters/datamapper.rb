module MerbSettings
  module Adapter
    module DataMapper

      def self.included(base)
        # Ensure base is a resource
        base.send(:include, ::DataMapper::Resource) unless ::DataMapper::Resource > base

        base.send(:include, Common)
        #base.send(:include, InstanceMethods)
        base.send(:extend,  ClassMethods)
      end

      module ClassMethods
        #retrieve a setting value bar [] notation
        def [](var)
          obj = find_by_var(var)
          var.value
        end

        #set a setting value by [] notation
        def []=(var, val)
          obj = find_by_var(var) || Setting.new(:name => var)
          obj.value = val
          obj.save
        end

        private

        def get_setting(var,type=nil,key=nil)

        end
      end # ClassMethods


      module DefaultModelSetup

        def self.included(base)
          base.class_eval do
            property :id, Serial
            property :name, String
            property :value, Yaml
            property :scope_id, Integer
            property :scope_type, String
            property :created_at, DateTime
            property :updated_at, DateTime
          end
        end
      end # DefaultModelSetup     
      

    end # DataMapper
  end # Adapter
end
