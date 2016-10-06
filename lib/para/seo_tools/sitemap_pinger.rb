module Para
  module SeoTools
    class SitemapPinger < Para::Job::Base
      def perform
        Para::SeoTools::Sitemap.ping_search_engines
      end

      private

      def progress_total
        nil
      end
    end
  end
end
