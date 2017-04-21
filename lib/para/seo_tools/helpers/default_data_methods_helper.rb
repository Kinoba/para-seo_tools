module Para
  module SeoTools
    module Helpers
      module DefaultDataMethodsHelper
        def default_title_for(resource)
          default_data_from_method_for(:title, resource)
        end

        def default_description_for(resource)
          default_data_from_method_for(:description, resource)
        end

        def default_image_for(resource)
          default_data_from_method_for(:image, resource)
        end

        # Try all default methods on resource
        def default_data_from_method_for(method, resource)
          return unless resource

          Para::SeoTools.send(:"#{ method }_methods").each do |method|
            data = resource.try(method)
            return data if data.present?
          end
          # Avoid returning the methods enumerable returned by the #each call
          nil
        end
      end
    end
  end
end
