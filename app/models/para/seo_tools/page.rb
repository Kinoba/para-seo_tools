module Para
  module SeoTools
    class Page < ActiveRecord::Base
      has_attached_file :image, styles: { thumb: '200x200#' }

      def meta_tag(name)
        send(name) || defaults[name.to_s]
      end

      def defaults
        if (hash = read_attribute(:defaults))
          hash
        else
          self.defaults = {}
        end
      end
    end
  end
end
