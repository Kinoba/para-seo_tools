module SeoTools
  class Page < ActiveRecord::Base
    belongs_to :meta_tags, class_name: '::MetaTags::List',
                           foreign_key: :meta_tags_list_id, 
                           dependent: :destroy

    accepts_nested_attributes_for :meta_tags

    def self.meta_tags_for(path)
      includes(:meta_tags).where(seo_tools_pages: { path: path })
        .first.try(:meta_tags)
    end
  end
end
