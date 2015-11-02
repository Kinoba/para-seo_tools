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

      def identifier
        @identifier ||= [name, resource.try(:id)].compact.join(':')
      end

      def display_name
        @display_name ||= [name, resource.try(:id)].compact.join(' #').humanize
      end

      def path
        @path ||= find_route
      end

      def model
        @model ||= ::SeoTools::Page.where(identifier: identifier).first_or_initialize.tap do |page|
          # Override path (i.e.: slug changed)
          page.path = path
          # Do not override meta tags if already present
          page.meta_tags ||= meta_tags
        end
      end

      def meta_tags
        @meta_tags ||= SeoTools::MetaTags.new(self).build
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
