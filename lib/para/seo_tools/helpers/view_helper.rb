module Para
  module SeoTools
    module Helpers
      module ViewHelper
        def meta_tags(options = {})
          MetaTags::Renderer.new(self, options).render
        end
      end
    end
  end
end
