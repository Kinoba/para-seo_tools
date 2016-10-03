module Para
  module SeoTools
    module Skeleton
      class ScopeAttributeUndefined < StandardError; end

      class PageBuilder
        include Rails.application.routes.url_helpers

        attr_reader :name, :resource, :locale, :defaults, :config

        def initialize(name, path: nil, resource: nil, **options)
          @name = name
          @path = path
          @resource = resource

          # Fetch locale on page build to allow calling the `page` skeleton
          # method inside a `I18n.with_locale` block
          #
          @locale = options.delete(:locale) || I18n.locale
          @defaults = options.delete(:defaults) || {}

          # Remaining options will be stored as config in a JSONB attribute
          @config = options
        end

        def identifier
          @identifier ||= [name, resource.try(:id)].compact.join(':')
        end

        def scope
          @scope ||= config[:scope]
        end

        def scope_attributes
          scope.each_with_object({}) do |attribute, hash|
            hash[attribute] = if (value = config[attribute])
              value
            elsif respond_to?(attribute)
              send(attribute)
            else
              raise ScopeAttributeUndefined, "Your Skeleton page is scoped " +
                "with the '#{ attribute }' attribute but you did not pass it " +
                "as a parameter of the #page : #{ inspect }"
            end
          end
        end

        def display_name
          @display_name ||= [name, resource.try(:id)].compact.join(' #').humanize
        end

        def path
          @path ||= find_route
        end

        def model
          @model ||= self.class.model_for(self).tap do |page|
            # Override path (i.e.: slug changed)
            page.path = path if path.to_s != page.path
            page.locale = locale
            # Do not override meta tags if already present
            page.defaults = defaults
            page.config = config
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

        def self.model_for(page)
          models[unique_identifier_for(page)] ||= ::Para::SeoTools::Page.new(
            identifier: page.identifier
          )
        end

        def self.models
          @models ||= Para::SeoTools::Page.all.each_with_object({}) do |page, hash|
            hash[unique_identifier_for(page)] = page
          end
        end

        def self.unique_identifier_for(page)
          Para::SeoTools::PageScoping.new(page).unique_identifier
        end
      end
    end
  end
end
