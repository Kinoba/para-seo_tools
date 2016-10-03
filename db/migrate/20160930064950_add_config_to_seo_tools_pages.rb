class AddConfigToSeoToolsPages < ActiveRecord::Migration
  def change
    add_column :seo_tools_pages, :config, :jsonb
  end
end
