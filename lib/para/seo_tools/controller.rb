module Para
  module SeoTools
    module Controller
      extend ActiveSupport::Concern

      included do
        before_action :store_request_for_meta_tags_processing
        helper_method :meta_tags_store
        before_action :fetch_meta_tags_page
      end

      def meta_tags_store
        @meta_tags_store ||= MetaTags::Store.new(self)
      end

      protected

      def meta_tags_from(resource)
        @resource = resource
      end

      def set_meta_tags_from_page(page)
        if page.kind_of?(Para::SeoTools::Page)
          meta_tags_store.page = page

          Para::SeoTools::Page::META_TAGS.each do |tag_name|
            if (value = page.meta_tag(tag_name)).present?
              set_meta_tag(tag_name, value)
            end
          end
        else
          page = Para::SeoTools::Page.where(identifier: page.to_s).first
          set_meta_tags_from_page(page) if page
        end
      end

      def set_meta_tag(tag_name, value)
        meta_tags_store.send(:"#{ tag_name }=", value)
      end

      def fetch_meta_tags_page
        if current_seo_tools_page
          set_meta_tags_from_page(current_seo_tools_page)
        end
      end

      def store_request_for_meta_tags_processing
        RequestStore.store[:'para.seo_tools.request'] = request
      end
    end
  end
end
