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

      def column?(attribute)
        resource.class.column_names.include?(attribute.to_s)
      end

      def uniqueness_scope_conditions
        return resource.class unless scoped?

        resource.scope_attributes.reduce(resource.class) do |query, (attribute, value)|
          if column?(attribute)
            query.where(attribute => value)
          else
            query.where("config->>'#{ attribute }' = ?", value)
          end
        end
      end

      def unique_identifier
        return resource.identifier unless scoped?
        resource.scope_attributes.merge(identifier: resource.identifier).to_json
      end
    end
  end
end
