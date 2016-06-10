class AddMetaTagsToSeoToolsPages < ActiveRecord::Migration
  def change
    change_table :seo_tools_pages do |t|
      t.string :title
      t.text :description
      t.text :keywords
      t.attachment :image
      t.text :canonical
      t.jsonb :defaults
    end
  end
end
