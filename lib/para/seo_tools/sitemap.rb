module Para
  module SeoTools
    class Sitemap
      def self.generate!
        build
        ::Sitemap::Generator.instance.build!
        ::Sitemap::Generator.instance.save(path)
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
            literal page.path, host: page.host
          end
        end
      end
    end
  end
end
