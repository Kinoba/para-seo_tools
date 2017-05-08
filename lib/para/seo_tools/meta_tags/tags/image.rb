module Para
  module SeoTools
    module MetaTags
      module Tags
        class Image < Base
          include Para::SeoTools::Helpers::DefaultDataMethodsHelper

          def value
            self.class.process(resource_image)
          end

          def self.process(value)
            url = url_from(value)

            if url.start_with?('http://')
              url
            else
              if (request = RequestStore.store[:'para.seo_tools.request'])
                URI.join(request.url, url).to_s
              else
                url
              end
            end
          end

          private

          def resource_image
            default_image_for(resource).try(:url)
          end

          def self.url_from(value)
            if Paperclip::Attachment === value
              value.url(:thumb)
            else
              value.to_s
            end
          end
        end
      end
    end
  end
end
