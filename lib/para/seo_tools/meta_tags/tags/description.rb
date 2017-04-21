module Para
  module SeoTools
    module MetaTags
      module Tags
        class Description < Base
          include Para::SeoTools::Helpers::DefaultDataMethodsHelper

          def value
            self.class.process(
              meta_taggable_description || resource_description || action_name
            )
          end

          def self.process(value)
            Processor.new.process(value)
          end

          private

          def meta_taggable_description
            resource && resource.meta_tagged? &&
              resource.meta_tags_list.meta_description.presence
          end

          def resource_description
            default_description_for(resource)
          end

          def action_name
            if (action_name = action_i18n(:description))
              return action_name
            end
          end

          class Processor
            include ActionView::Helpers::TextHelper

            def process(value)
              truncate(sanitize(value, tags: []), length: 250)
            end
          end
        end
      end
    end
  end
end
