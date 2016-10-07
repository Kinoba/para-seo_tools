module Para
  module SeoTools
    class Engine < Rails::Engine
      config.after_initialize do
        Para::SeoTools::Skeleton.load
      end

      initializer 'para.seo_tools.include_controller_mixin' do
        ActiveSupport.on_load(:action_controller) do
          include Para::SeoTools::Controller
          include Para::SeoTools::Helpers::PageHelper
        end
      end

      initializer "para.seo_tools.include_view_helpers" do
        ActiveSupport.on_load(:action_view) do
          include Para::SeoTools::Helpers::ViewHelper
        end
      end
    end
  end
end
