module Para
  module SeoTools
    module MetaTags
      module Vendors
        class Twitter < Para::SeoTools::MetaTags::Vendors::Base
          def tags
            [:title, :description, :image, :url, :site, :card]
          end

          protected

          def key_name
            'name'
          end

          def namespace
            'twitter'
          end
        end
      end
    end
  end
end
