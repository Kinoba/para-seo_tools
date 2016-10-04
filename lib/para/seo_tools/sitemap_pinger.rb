module Para
  module SeoTools
    class SitemapPinger < Para::Job::Base
      def perform
        SitemapGenerator::Sitemap.default_host = Para::SeoTools.full_host
        SitemapGenerator::Sitemap.ping_search_engines
      end

      private

      def progress_total
        nil
      end
    end
  end
end
