module MerbSettings
  module Adapter
    module Common

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.send(:extend,  ClassMethods)
      end


      module InstanceMethods

      end

      module ClassMethods
        def method_missing(method, *args)
          method_name = method.to_s

          if method_name.include? '='
            #set a value for a variable
            var_name = method_name.gsub('=', '')
            value = args.first
            self[var_name] = value
          else
            #retrieve a value
            self[method_name]
          end
        end

        #destroy the specified settings record
        def destroy(var_name)
          var_name = var_name.to_s
          if self[var_name]
            find(:first, :include => :setting_type, :conditions => ['var = ?', var_name]).destroy
            true
          else
            raise SettingNotFound, "Setting variable \"#{var_name}\" not found"
          end
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

        #retrieve a setting value bar [] notation
        def [](var_name)
          #retrieve a setting
          var_name = var_name.to_s

          #if var = find(:first, :conditions => ['var = ?', var_name])
          begin
            @@cache[var_name] ||= find(:first, :select => 'value', :include => :setting_type, :conditions => ['site_id = ? AND var = ?', ActiveRecord::Base.site_id, var_name])
            YAML::load(@@cache[var_name].value)
          rescue
            var = SettingType.find_by_var(var_name)
            # save the default value the first time it is accessed
            self[var_name] = YAML::load(var.default_value)
            YAML::load(var.default_value)
          end
        end

        #set a setting value by [] notation
        def []=(var_name, value)
          #if self[var_name] != value
          var_name = var_name.to_s

          #record = Setting.find(:first, :conditions => ['var = ?', var_name]) || Setting.new(:var => var_name)
          test = @@site_id
          setting = find(:first, :include => :setting_type, :conditions => ['site_id = ? AND var = ?', ActiveRecord::Base.site_id, var_name])
          if record.nil?
            type = SettingType.find_by_var(var_name)
            record = Setting.new(:setting_type => type)
          end
          @@cache[var_name] = value
          record.value = value.to_yaml
          #TODO why cant i just use @@site_id????
          record.site = Site.find(ActiveRecord::Base.site_id)
          record.save
          #end
        end

      end

    end
  end
end
