module Para
  module SeoTools
    class Sitemap
      def self.build
        ::Sitemap::Generator.instance.load :host => Para::SeoTools.host do
          Para::SeoTools::Skeleton.site.pages.each do |page|
            literal page.path, page.sitemap_options
          end
        end
      end
    end
  end
end
