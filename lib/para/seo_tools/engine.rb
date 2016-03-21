module Para
  module SeoTools
    class Engine < Rails::Engine
      config.after_initialize do
        Para::SeoTools::Skeleton.load
      end

      initializer 'Include controller mixin' do
        ActiveSupport.on_load(:action_controller) do
          include Para::SeoTools::Controller
        end
      end

      rake_tasks do
        Dir[File.expand_path('../../tasks/**/*.rake', __FILE__)].each do |path|
          load(path)
        end
      end
    end
  end
end
