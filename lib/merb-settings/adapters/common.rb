module MerbSettings
  module Adapter
    module Common

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend,  ClassMethods)
      end


      module InstanceMethods
        def value
          YAML::load(self[:value])
        end

        def value=(val)
          self[:value] = val.to_yaml
        end
      end

      module ClassMethods
        def method_missing(method, *args)
          method_name = method.to_s

          if method_name =~ /=$/
            #set a value for a variable
            var = method_name.gsub('=', '')
            val = args.first
            self[var] = val
          else
            #retrieve a value
            self[method_name]
          end
        end

        #destroy the specified settings record
        def destroy(var)
          var_name = var.to_s
          obj = self[var_name]
          val = obj.value
          obj.destroy
          val
        end

        #retrieve all settings as a hash
        def all
          vars = find(:all, :include => :setting_type, :select => 'var, value')

          result = {}
          vars.each do |record|
            result[record.var] = YAML::load(record.value)
          end
          result.with_indifferent_access
        end

      end

    end
  end
end
