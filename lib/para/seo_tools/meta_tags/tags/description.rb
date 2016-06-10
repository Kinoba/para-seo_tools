module Para
  module SeoTools
    module MetaTags
      module Tags
        class Description < Base
          def value
            self.class.process(
              meta_taggable_description || instance_description || action_name
            )
          end

          def self.process(value)
            Processor.new.process(value)
          end

          private

          def meta_taggable_description
            instance && instance.meta_tagged? &&
              instance.meta_tags_list.meta_description.presence
          end

          def instance_description
            if instance
              Para::SeoTools.description_methods.each do |method|
                if instance.respond_to?(method)
                  if (description = instance.send(method).presence)
                    return description
                  end
                end
              end

              return nil
            end
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
