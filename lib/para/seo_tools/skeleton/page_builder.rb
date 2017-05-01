module Para
  module SeoTools
    module Skeleton
      class ScopeAttributeUndefined < StandardError; end

      class PageBuilder
        include Rails.application.routes.url_helpers
        include ActionDispatch::Routing::PolymorphicRoutes
        include Para::SeoTools::Helpers::DefaultDataMethodsHelper

        attr_reader :name, :raw_name, :resource, :locale, :defaults, :config

        def initialize(name, path: nil, resource: nil, **options)
          # Store raw name argument to be processed by other methods, for
          # example to build routes or get resource
          @raw_name = name

          @name = process_name(raw_name)
          @path = path
          @resource = resource || resource_from(raw_name)

          # Fetch locale on page build to allow calling the `page` skeleton
          # method inside a `I18n.with_locale` block
          #
          @locale = options.delete(:locale) || I18n.locale
          @defaults = options.delete(:defaults) || {}

          # Remaining options will be stored as config in a JSONB attribute
          @config = options
        end

        # Iterate on all name parts and process ActiveRecord objects as
        # <model_name>:<id> parts. This allow simple resource forwarding in
        # the app's skeleton as : page(resource) or page([parent, resource])
        # instead of manually building those arrays.
        #
        def process_name(name)
          parts = Array.wrap(name).each_with_object([]) do |part, buffer|
            case part
            when ActiveRecord::Base
              buffer.concat([part.class.model_name.element, part.id])
            else
              buffer << part
            end
          end.join(':')
        end

        # If the name array contains an ActiveRecord object as the last, or the
        # name is actually an ActiveRecord object, we use it as the resource
        # for our page
        #
        def resource_from(name)
          parts = Array.wrap(name)
          parts.last if parts.last.is_a?(ActiveRecord::Base)
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
            page.defaults = process_defaults
            page.config = config
          end
        end

        private

        # Find a route matching the name of the page, passing the resource
        # for member routes to work out of the box
        def find_route
          if respond_to?(:"#{ name }_path")
            send(:"#{ name }_path", resource)
          elsif (path = polymorphic_path(raw_name))
            path
          end
        end

        def process_defaults
          return {} if defaults == false

          defaults[:title] ||= default_title_for(resource)
          defaults[:description] ||= default_description_for(resource)

          defaults
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
