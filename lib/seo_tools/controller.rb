module SeoTools
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :fetch_meta_tags_for_current_path
    end

    private

    def fetch_meta_tags_for_current_path
      if (meta_tags = SeoTools::Page.meta_tags_for(request.path))
        set_meta_tags_from_list(meta_tags)
      end
    end
  end
end
