module MerbSettings
  module ScopedHelpers
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def get_setting(var)
        # get the called 
      end

      def set_setting(var, val)
      end
    end

  end # ScopedHelpers
end

