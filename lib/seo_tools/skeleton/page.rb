module SeoTools
  module Skeleton
    class Page
      include Rails.application.routes.url_helpers

      attr_reader :name, :resource, :options

      def initialize(name, path: nil, resource: nil, **options)
        @name = name
        @path = path
        @resource = resource
        @options = options
      end

      def path
        @path ||= find_route
      end

      def sitemap_options
        [:priority, :change_frequency].each_with_object({}) do |param, hash|
          hash[param] = options[param] if options.key?(param)
        end
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
