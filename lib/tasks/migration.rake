namespace :seo_tools do
  task migrate_from_meta_tags: :environment do
    ActiveRecord::Base.transaction do
      pages = Para::SeoTools::Page.all

      meta_tags = MetaTags::List.where(identifier: pages.map(&:identifier)).each_with_object({}) do |mt, hash|
        hash[mt.identifier] = mt
      end

      print " * Migrating data for #{ pages.length } pages and #{ meta_tags.length } meta tags items ... "

      pages.each do |page|
        next unless (mt = meta_tags[page.identifier])
        page.update(title: mt.meta_title, description: mt.meta_description, keywords: mt.meta_keywords)
      end

      puts 'done !'
    end
  end
end
