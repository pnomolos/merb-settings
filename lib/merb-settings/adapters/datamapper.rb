module MerbSettings
  module Adapter
    module DataMapper

      def self.included(base)
        # Ensure base is a resource
        base.send(:include, ::DataMapper::Resource) unless ::DataMapper::Resource > base

        base.send(:include, Common)
        #base.send(:include, InstanceMethods)
        base.send(:extend,  ClassMethods)

        MS[:setting] = base
      end

      module ClassMethods

        def get_all(type=nil,key=nil)
          all(:scope_type.eql => type, :scope_id.eql => key)
        end

        def getter(var,type=nil,key=nil)
          s = first(:name.eql => var, :scope_type.eql => type, :scope_id.eql => key)
          # get a default if none found
          # else return value or nil or exception??
          YAML::load(s.value)
        end

        def setter(var,val,type=nil,key=nil)
          s = getter(var,type,key)
          if not s
            s = MS[:setting].new(:name => var, :scope_type => type, :scope_id => key)
          end
          s.value = val.to_yaml
          s.save
        end
      end # ClassMethods


      module DefaultModelSetup

        def self.included(base)
          base.class_eval do
            property :id, Serial
            property :name, String
            property :value, Yaml
            property :scope_id, String
            property :scope_type, String
            property :created_at, DateTime
            property :updated_at, DateTime
          end
        end
      end # DefaultModelSetup     
      

    end # DataMapper
  end # Adapter
end
