module SeoTools
  module Skeleton
    class Site
      include Rails.application.routes.url_helpers

      def page(name, options = {} , &block)
        page = Skeleton::Page.new(name, options)
        page.instance_exec(&block) if block
        pages << page
      end

      def pages
        @pages ||= []
      end
    end
  end
end
