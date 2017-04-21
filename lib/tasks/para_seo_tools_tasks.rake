namespace :para do
  namespace :seo_tools do
    namespace :skeleton do
      desc "Builds or refreshes the app skeleton."
      task build: :environment do
        puts "  * Build app skeleton ..."
        Para::SeoTools::Skeleton.build(load_skeleton: true)
      end
    end

    namespace :sitemap do
      desc "Generates a new sitemap."
      task generate: :environment do
        Rake.application.invoke_task('para:seo_tools:skeleton:build')

        puts "  * Generate sitemap ..."
        Para::SeoTools::Sitemap.generate!
      end

      desc "Ping engines."
      task ping: :environment do
        SitemapGenerator::Sitemap.ping_search_engines
      end
    end
  end
end
