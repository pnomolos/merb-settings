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
          vars = get_all
          result = {}
          vars.each do |s|
            result[s.name] = YAML::load(s.value)
          end
          result
        end

        def [](var)
          getter(var)
        end

        #set a setting value by [] notation
        def []=(var, val)
          setter(var,val)
        end

      end

    end
  end
end
