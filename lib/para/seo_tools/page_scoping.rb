# Common class used by the Page model and PageBuilder to build and handle
# pages scoping and building their unique identifiers
#
module Para
  module SeoTools
    class PageScoping
      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def scoped?
        resource.scope.present?
      end

      def uniqueness_scope_conditions
        return resource.class unless scoped?

        self.class.scope_with(resource.class, resource.scope_attributes)
      end

      def unique_identifier
        return resource.identifier unless scoped?

        resource.scope_attributes.merge(identifier: resource.identifier).to_json
      end

      def alternate_language_siblings
        attributes = resource.scope_attributes.reject { |attribute, _| attribute == 'locale' }
        self.class.scope_with(resource.siblings, attributes)
      end

      def self.scope_with(resource_class, attributes)
        attributes.reduce(resource_class) do |query, (attribute, value)|
          if column?(resource_class, attribute)
            query.where(attribute => value)
          else
            query.where("config->>'#{ attribute }' = ?", value)
          end
        end
      end

      def self.column?(resource_class, attribute)
        resource_class.column_names.include?(attribute.to_s)
      end
    end
  end
end
