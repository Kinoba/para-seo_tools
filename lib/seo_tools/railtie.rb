module SeoTools
  class Railtie < Rails::Railtie
    config.after_initialize do
      # Ensure routes are loaded to allow skeleton to call routes name helpers
      Rails.application.reload_routes!
      # Load the skeleton file
      require skeleton_path if File.exists?(skeleton_path)
    end

    rake_tasks do
      Dir[File.expand_path('../../tasks/**/*.rake', __FILE__)].each do |path|
        load(path)
      end
    end

    private

    def skeleton_path
      @skeleton_path ||= File.expand_path('config/skeleton.rb', Rails.root)
    end
  end
end
