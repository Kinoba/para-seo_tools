module Para
  module SeoTools
    module Controller
      extend ActiveSupport::Concern

      included do
        before_action :fetch_meta_tags_page
      end

      private

      def fetch_meta_tags_page
        # if (page = Para::SeoTools::Page.find_by_path(request.path))
        #   set_meta_tags_from_list(meta_tags)
        # end
      end
    end
  end
end
