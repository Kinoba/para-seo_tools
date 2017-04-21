module Para
  module SeoTools
    module MetaTags
      module Tags
        class Title < Base
          include Para::SeoTools::Helpers::DefaultDataMethodsHelper

          def value
            meta_taggable_title || resource_title || action_name || model_name_translation
          end

          private

          def meta_taggable_title
            resource && resource.meta_tagged? &&
              resource.meta_tags_list.meta_title.presence
          end

          def resource_title
            default_title_for(resource)
          end

          def action_name
            if (action_name = action_i18n(:title))
              return action_name
            end
          end

          def model_name_translation
            return unless model_name
            model_key = "activerecord.models.#{ model_name }"

            if (translation = I18n.t("#{ model_key }.other", default: "").presence)
              translation
            elsif (translation = I18n.t(model_key, default: "").presence)
              translation.pluralize
            end
          end
        end
      end
    end
  end
end
