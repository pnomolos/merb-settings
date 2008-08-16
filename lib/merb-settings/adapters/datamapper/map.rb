module MerbSettings
  module Adapter
    module DataMapper
      module Map

        def self.included(base)
          base.send(:include, InstanceMethods)
          base.send(:extend,  ClassMethods)
        end

        module InstanceMethods
        end

        module ClassMethods

          def getter(var=nil,type=nil,key=nil)
            result = nil
            if var
              s = first(:name.eql => var, :scope_type.eql => type, :scope_id.eql => key)
              # get a default if none found
              # else return value or nil or exception??
              result = YAML::load(s.value.to_s)
            else
              result = all(:scope_type.eql => type, :scope_id.eql => key)
            end
            result
          end

          def setter(var,val,type=nil,key=nil)
            s = first(:name.eql => var, :scope_type.eql => type, :scope_id.eql => key)
            if s.nil?
              s = new(:name => var, :scope_type => type, :scope_id => key)
            end
            s.update_attributes(:value => val.to_yaml)
          end
        end # ClassMethods

      end # Map
    end # DataMapper
  end # Adapter
end

