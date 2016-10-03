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
        @instance = resource
      end

      def set_meta_tags_from_page(page)
        if page.kind_of?(Para::SeoTools::Page)
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
        page_conditions = Para::SeoTools::Page.where(path: request.path)
        page_conditions = page_conditions.with_subdomain(request.subdomain) if Para::SeoTools.handle_subdomain
        page_conditions = page_conditions.with_domain(request.domain) if Para::SeoTools.handle_domain

        if (page = page_conditions.first)
          set_meta_tags_from_page(page)
        end
      end

      def store_request_for_meta_tags_processing
        RequestStore.store[:'para.seo_tools.request'] = request
      end
    end
  end
end
