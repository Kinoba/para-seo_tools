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
          Para::SeoTools::Page.where('path ~* ?', Para::SeoTools.sitemap_path_regexp).find_each do |page|
            add page.path, host: page.host
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
