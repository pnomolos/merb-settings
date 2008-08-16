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

          def getter(options = {})
            options[:type] ||= nil
            options[:key] ||= nil
            if options[:name]
              s = first(:name.eql => options[:name], 
                        :scope_type.eql => options[:type], 
                        :scope_id.eql => options[:key])
              # get a default if none found
              # else return value or nil or exception??
              result = YAML::load(s.value.to_s)
            else
              result = {}
              set = all(:scope_type.eql => options[:type], :scope_id.eql => options[:key])
              set.each do |s|
                result[s.name] = YAML::load(s.value.to_s)
              end
            end
            result
          end

          def setter(var,val, options = {})
            options[:type] ||= nil
            options[:key] ||= nil
            s = first(:name.eql => var, :scope_type.eql => options[:type], :scope_id.eql => options[:key])
            if s.nil?
              s = new(:name => var, :scope_type => options[:type], :scope_id => options[:key])
            end
            s.update_attributes(:value => val.to_yaml)
          end
        end # ClassMethods

      end # Map
    end # DataMapper
  end # Adapter
end

