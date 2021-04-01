module Para
  module SeoTools
    class Sitemap
      def self.prepare
        SitemapGenerator::Sitemap.sitemaps_path = Para::SeoTools.sitemaps_path
        SitemapGenerator::Sitemap.default_host = Para::SeoTools.full_host
      end

      def self.generate!
        prepare

        SitemapGenerator::Sitemap.create do
          Para::SeoTools::Page.where(
            # Allow filtering paths in sitemap with the `#sitemap_path_regexp`
            # config in the seo tools initializer
            "path ~* ? AND " +
            # Do not push pages with noindex to sitemap
            "(CAST(config->>'noindex' AS BOOLEAN) != ? OR (config->>'noindex') IS NULL) AND " +
            # Do not push pages that have a different canonical URL to sitemap
            "(CAST(config->>'canonical' AS TEXT) = path OR (config->>'canonical') IS NULL)",

            Para::SeoTools.sitemap_path_regexp, true
          ).find_each do |page|
            add(page.path, host: page.host) unless page.config['noindex']
          end
        end
      end

      def self.ping_search_engines
        prepare

        SitemapGenerator::Sitemap.ping_search_engines
      end
    end
  end
end
