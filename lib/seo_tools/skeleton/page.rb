module SeoTools
  module Skeleton
    class Page
      include Rails.application.routes.url_helpers

      attr_reader :name, :resource

      def initialize(name, options = {})
        @name = name
        @path = options[:path]
        @resource = options[:resource]
      end

      def path
        @path ||= find_route
      end

      private

      # Find a route matching the name of the page, passing the resource
      # for member routes to work out of the box
      def find_route
        if respond_to?(:"#{ name }_path")
          send(:"#{ name }_path", resource)
        end
      end
    end
  end
end
