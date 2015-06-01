module SeoTools
  class MetaTags
    attr_reader :site

    def self.build_from(site)
      new(site).build_all
    end

    def initialize(site)
      @site = site
    end

    def build_all
      site.pages.each do |page|
        # Ensure the resource is meta_taggable
        if page.resource && !page.resource.class.meta_taggable?
          page.resource.class.send(:acts_as_meta_taggable)
        end

        # Try to find a stored meta_tags list containing the configured
        # meta_tags from the admins
        unless (list = ::MetaTags::List.where(identifier: page.identifier).first)
          ::MetaTags::List.create!(
            name: page.display_name,
            identifier: page.identifier,
            meta_taggable: page.resource
          )
        end
      end
    end
  end
end
