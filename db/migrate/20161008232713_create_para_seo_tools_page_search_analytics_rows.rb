class CreateParaSeoToolsPageSearchAnalyticsRows < ActiveRecord::Migration
  def change
    create_table :seo_tools_page_search_analytics_rows do |t|
      t.references :page, index: true

      t.string :country
      t.string :query
      t.string :device

      t.integer :clicks, default: 0
      t.integer :impressions, default: 0
      t.float :ctr, default: 0.0
      t.integer :position, default: 0

      t.date :date
    end

    add_foreign_key :seo_tools_page_search_analytics_rows, :seo_tools_pages, column: :page_id

    add_index :seo_tools_page_search_analytics_rows,
              [:page_id, :country, :query, :device, :date],
              name: 'analytics_row_unique_idx',
              unique: true
  end
end
