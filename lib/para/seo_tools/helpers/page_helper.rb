module Para
  module SeoTools
    module Helpers
      module PageHelper
        extend ActiveSupport::Concern

        included do
          # Allow module methods to be called from the view when the PageHelper
          # module is included in a controller
          if respond_to?(:helper_method)
            helper_method :current_seo_tools_page,
                          :seo_tools_page_for,
                          :seo_tools_pages_for,
                          :seo_tools_scoped_sibling_for,
                          :seo_tools_scoped_siblings_for
          end
        end

        def current_seo_tools_page
          RequestStore.store['para.seo_tools.current_seo_tools_page'] ||=
            seo_tools_page_for({ path: request.path }.reverse_merge(seo_tools_scope_for(request)))
        end

        # Retrieve the first page that matches the given scope conditions
        #
        def seo_tools_page_for(scope_hash = {})
          seo_tools_pages_for(scope_hash).first
        end

        # Find all the pages with the given scope conditions, merged with the
        # current page ones.
        #
        def seo_tools_pages_for(scope_hash = {})
          Para::SeoTools::Page.scope_with(scope_hash)
        end

        def seo_tools_scoped_sibling_for(*args)
          seo_tools_scoped_siblings_for(*args).first
        end

        def seo_tools_scoped_siblings_for(path, scope_hash = {})
          source_page = if Hash === path
            scope_hash = path
            current_seo_tools_page
          else
            Para::SeoTools::Page.find_by_path(path)
          end

          return Para::SeoTools::Page.none unless source_page

          scope_hash = scope_hash.reverse_merge(seo_tools_scope_for(request))
          source_page.siblings.scope_with(scope_hash)
        end

        protected

        # Return a simple scopes hash, letting the Page.scope_with method handle
        # column and JSON field backed attributes
        #
        # This method is meant to be overriden in app controllers to scope
        #
        def seo_tools_scope_for(request)
          {}.tap do |hash|
            hash[:subdomain] = request.subdomain if Para::SeoTools.handle_subdomain
            hash[:domain] = request.domain if Para::SeoTools.handle_domain
            hash[:locale] = I18n.locale if I18n.available_locales.length > 1
          end
        end
      end
    end
  end
end
