namespace :para do
  namespace :seo_tools do
    namespace :skeleton do
      desc "Builds or refreshes the app skeleton."
      task build: :environment do
        Para::SeoTools::Skeleton.build(load_skeleton: true)
      end
    end

    namespace :sitemap do
      desc "Generates a new sitemap."
      task generate: :environment do
        Para::SeoTools::Sitemap.generate!
      end

      desc "Ping engines."
      task ping: :environment do
        ::Sitemap::Ping.send_request(Para::SeoTools::Sitemap.path)
      end
    end
  end
end
