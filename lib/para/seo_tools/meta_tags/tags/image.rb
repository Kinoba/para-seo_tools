module Para
  module SeoTools
    module MetaTags
      module Tags
        class Image < Base
          def value
            self.class.process(instance_image)
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

          def instance_image
            if member_action?
              Para::SeoTools.image_methods.each do |method|
                if instance.respond_to?(method) && instance.send(method)
                  return instance.send(method).url
                end
              end

              nil
            end
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
