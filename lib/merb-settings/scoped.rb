module MerbSettings
  module ScopedHelpers

    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def get_setting(var)
        type = self.type
        key = self.to_param

        MS[:setting].getter(var,type,key)
      end

      def set_setting(var, val)
        type = self.type
        key = self.to_param

        MS[:setting].setter(var,val,type,key)
      end

      def settings
        type = self.type
        key = self.to_param

        MS[:setting].get_all(type,key)
      end
    end

  end # ScopedHelpers
end

