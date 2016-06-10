module Para
  module SeoTools
    module Skeleton
      class Site
        include Rails.application.routes.url_helpers

        def page(name, options = {} , &block)
          page = Skeleton::Page.new(name, options)
          pages << page
        end

        def pages
          @pages ||= []
        end
      end
    end
  end
end
