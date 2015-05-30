module SeoTools
  class Railtie < Rails::Railtie
    config.after_initialize do
      Rails.application.reload_routes!
      require File.expand_path('config/skeleton.rb', Rails.root)
    end
  end
end
