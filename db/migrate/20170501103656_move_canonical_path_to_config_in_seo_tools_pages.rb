class MoveCanonicalPathToConfigInSeoToolsPages < ActiveRecord::Migration[5.0]
  def up
    Para::SeoTools::Page.find_each do |page|
      if (canonical = page.read_attribute(:canonical)).present?
        page.send(:write_store_attribute, :config, :canonical, canonical)
        page.save!
      end
    end

    remove_column :seo_tools_pages, :canonical
  end

  def down
    add_column :seo_tools_pages, :canonical, :text

    Para::SeoTools::Page.find_each do |page|
      if (canonical = page.send(:read_store_attribute, :config, :canonical)).present?
        page.write_attribute(:canonical, canonical)
        page.save!
      end
    end
  end
end
