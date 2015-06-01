module SeoTools
  class MetaTags
    attr_reader :page

    def initialize(page)
      @page = page
    end

    def build
      # Ensure the resource is meta_taggable
      if page.resource && !page.resource.class.meta_taggable?
        page.resource.class.send(:acts_as_meta_taggable)
      end

      # Try to find a stored meta_tags list containing the configured
      # meta_tags from the admins
      ::MetaTags::List.where(identifier: page.identifier).first_or_create! do |list|
        list.name = page.display_name
        list.identifier = page.identifier
        list.meta_taggable = page.resource
      end
    end
  end
end
