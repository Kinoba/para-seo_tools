class CreateSeoToolsPages < ActiveRecord::Migration
  def change
    create_table :seo_tools_pages do |t|
      t.string :identifier
      t.string :path
      t.references :meta_tags_list, index: true

      t.timestamps null: false
    end

    add_index :seo_tools_pages, :identifier
    add_index :seo_tools_pages, :path
  end
end
