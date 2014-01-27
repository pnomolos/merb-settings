module MerbSettings
  module Adapter
    module Common
      def self.included(base)
        #base.send(:include, InstanceMethods)
        base.send(:extend,  ClassMethods)
      end


      module InstanceMethods
      end

      module ClassMethods
        def self.extended(base)
          class << base
            attr_accessor :_settings_cache
            @_settings_cache = {}
          end
          
          base.class_eval do
            @_settings_cache = {}
          end
        end
        
        def method_missing(method, *args)
          method_name = method.to_s

          if method_name =~ /=$/
            #set a value for a variable
            var = method_name.gsub('=', '')
            val = args.first
            self._settings_cache[var] = val
            setter(var, val)
          else
            self._settings_cache[method_name] ||= getter({:name => method_name})
          end
        end

        #destroy the specified settings record
        def destroy(var)
          cache = self.class.instance_variable_get('@cache'.to_sym)
          var_name = var.to_s
          obj = getter({:name => var_name})
          val = obj.value
          self._settings_cache[var].delete
          obj.destroy
          val
        end

        #retrieve all settings as a hash
        def get_all
          vars = getter
          result = {}
          vars.each do |s|
            result[s.name] = YAML::load(s.value.to_s)
          end
          result
        end

      end

    end
  end
end
