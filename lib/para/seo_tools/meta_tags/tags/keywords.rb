module Para
  module SeoTools
    module MetaTags
      module Tags
        class Keywords < Base
          def value
            meta_taggable_keywords
          end

          private

          def meta_taggable_keywords
            resource && resource.meta_tagged? &&
              resource.meta_tags_list.meta_keywords.presence
          end
        end
      end
    end
  end
end
