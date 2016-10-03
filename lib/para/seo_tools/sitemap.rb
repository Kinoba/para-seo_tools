module Para
  module SeoTools
    class Sitemap
      def self.generate!
        puts " * GENERATE SITEMAP ..."

        build

        puts " * BUILD ..."

        ::Sitemap::Generator.instance.build!

        puts " * SAVE ..."

        ::Sitemap::Generator.instance.save(path)

        puts " * SAVED !"
      end

      def self.path
        @path ||= begin
          root = ::Sitemap.configuration.save_path || ENV["LOCATION"] || Rails.public_path
          File.join(root, "sitemap.xml")
        end
      end

      def self.build
        ::Sitemap::Generator.instance.load do
          Para::SeoTools::Page.find_each do |page|
            literal page.path, host: page.sitemap_host
          end
        end
      end
    end
  end
end
