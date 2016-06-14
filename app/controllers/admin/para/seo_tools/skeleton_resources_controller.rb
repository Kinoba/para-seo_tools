module Admin
  module Para
    module SeoTools
      class SkeletonResourcesController < ::Para::Admin::CrudResourcesController
        def index
          super
          @available_locales = ::Para::SeoTools::Page.group(:locale).pluck(:locale)
        end

        def refresh
          ::Para::SeoTools::Skeleton.with_logging do
            ::Para::SeoTools::Skeleton.load
            ::Para::SeoTools::Skeleton::Worker.perform
          end

          redirect_to after_form_submit_path
        end
      end
    end
  end
end
