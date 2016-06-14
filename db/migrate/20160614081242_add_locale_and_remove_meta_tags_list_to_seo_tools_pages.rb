class AddLocaleAndRemoveMetaTagsListToSeoToolsPages < ActiveRecord::Migration
  def change
    change_table :seo_tools_pages do |t|
      t.remove_references :meta_tags_list, index: true
      t.string :locale
    end
  end
end
