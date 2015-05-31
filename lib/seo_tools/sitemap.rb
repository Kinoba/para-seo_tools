module SeoTools
  class Sitemap
    def self.build
      ::Sitemap::Generator.instance.load :host => SeoTools.host do
        SeoTools::Skeleton.site.pages.each do |page|
          literal page.path, page.sitemap_options
        end
      end
    end
  end
end
