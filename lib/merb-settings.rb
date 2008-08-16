if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "merb-settings/merbtasks", "merb-settings/slicetasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  Merb::Slices::config[:merb_settings][:foo] ||= :bar
  
  # All Slice code is expected to be namespaced inside a module
  module MerbSettings
    
    # Slice metadata
    self.description = "MerbSettings"
    self.version = "0.0.1"
    self.author = "Felix McCoey"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(MerbSettings)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :merb_settings_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
    end
    
    # This sets up a very thin slice's structure.
    def self.setup_default_structure!
      self.push_app_path(:root, Merb.root / 'slices' / self.identifier, nil)
      
      self.push_path(:stub, root_path('stubs'), nil)
      self.push_app_path(:stub, app_dir_for(:root), nil)
      
      self.push_path(:application, root, 'application.rb')
      self.push_app_path(:application, app_dir_for(:root), 'application.rb')
            
      self.push_path(:public, root_path('public'), nil)
      self.push_app_path(:public, Merb.root / 'public' / 'slices' / self.identifier, nil)
      
      public_components.each do |component|
        self.push_path(component, dir_for(:public) / "#{component}s", nil)
        self.push_app_path(component, app_dir_for(:public) / "#{component}s", nil)
      end
    end
    
  end
  
  # Setup the slice layout for MerbSettings
  #
  # Use MerbSettings.push_path and MerbSettings.push_app_path
  # to set paths to merb-settings-level and app-level paths. Example:
  #
  # MerbSettings.push_path(:application, MerbSettings.root)
  # MerbSettings.push_app_path(:application, Merb.root / 'slices' / 'merb-settings')
  # ...
  #
  # Any component path that hasn't been set will default to MerbSettings.root
  #
  # For a very thin slice we just add application.rb and :public locations.
  MerbSettings.setup_default_structure!
  
  # Add dependencies for other MerbSettings classes below. Example:
  # dependency "merb-settings/other"
  
end
