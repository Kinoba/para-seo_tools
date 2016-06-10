module Para
  module SeoTools
    class Page < ActiveRecord::Base
      META_TAGS = :title, :description, :keywords, :image, :canonical

      has_attached_file :image, styles: { thumb: '200x200#' }
      validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }

      def meta_tag(name)
        process(name, send(name) || defaults[name.to_s])
      end

      def defaults
        if (hash = read_attribute(:defaults))
          hash
        else
          self.defaults = {}
        end
      end

      private

      def process(name, value)
        if (processor = Para::SeoTools::MetaTags::Tags[name])
          processor.process(value)
        else
          value
        end
      end
    end
  end
end
