module Para
  module SeoTools
    class SitemapPinger < Para::Job::Base
      def perform
        Para::SeoTools::Sitemap.ping_search_engines
      end
    end
  end
end
