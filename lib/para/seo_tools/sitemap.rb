module Para
  module SeoTools
    class Sitemap
      def self.build
        ::Sitemap::Generator.instance.load host: Para::SeoTools.host do
          Para::SeoTools::Page.find_each do |page|
            literal page.path
          end
        end
      end
    end
  end
end
