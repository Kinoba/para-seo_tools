module Para
  module SeoTools
    class Sitemap
      def self.generate!
        SitemapGenerator::Sitemap.default_host = Para::SeoTools.full_host

        SitemapGenerator::Sitemap.create do
          Para::SeoTools::Page.find_each do |page|
            add page.path, host: page.host
          end
        end
      end
    end
  end
end
