module Para
  module SeoTools
    module Admin
      class SkeletonResourcesController < ::Para::Admin::CrudResourcesController
        include Para::SeoTools::Oauth::ControllerClient

        def index
          super
          @available_locales = ::Para::SeoTools::Page.group(:locale).pluck(:locale)
        end
      end
    end
  end
end
