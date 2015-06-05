module SeoTools
  class Engine < Rails::Engine
    config.autoload_paths << File.expand_path('../../../app/components')

    config.after_initialize do
      # Ensure routes are loaded to allow skeleton to call routes name helpers
      Rails.application.reload_routes!
      # Skeleton file path
      skeleton_path = File.expand_path('config/skeleton.rb', Rails.root)
      # Load the skeleton file
      require skeleton_path if File.exists?(skeleton_path)
    end

    initializer 'Include controller mixin' do
      ActiveSupport.on_load(:action_controller) do
        include SeoTools::Controller
      end
    end

    rake_tasks do
      Dir[File.expand_path('../../tasks/**/*.rake', __FILE__)].each do |path|
        load(path)
      end
    end
  end
end
