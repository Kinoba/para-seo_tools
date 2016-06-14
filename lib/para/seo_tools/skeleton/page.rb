module Para
  module SeoTools
    module Skeleton
      class Page
        include Rails.application.routes.url_helpers

        attr_reader :name, :resource, :options, :locale

        def initialize(name, path: nil, resource: nil, **options)
          @name = name
          @path = path
          @resource = resource
          @options = options

          # Fetch locale on page build to allow calling the `page` skeleton
          # method inside a `I18n.with_locale` block
          #
          @locale = options.fetch(:locale, I18n.locale)
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
          @model ||= self.class.model_for(identifier).tap do |page|
            # Override path (i.e.: slug changed)
            page.path = path if path.to_s != page.path
            page.locale = locale
            # Do not override meta tags if already present
            page.defaults = options[:defaults] || {}
          end
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

        def self.model_for(identifier)
          models[identifier] ||= ::Para::SeoTools::Page.new(identifier: identifier)
        end

        def self.models
          @models ||= Para::SeoTools::Page.all.each_with_object({}) do |page, hash|
            hash[page.identifier] = page
          end
        end
      end
    end
  end
end
