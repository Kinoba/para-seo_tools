module SeoTools
  module Skeleton
    extend ActiveSupport::Autoload

    autoload :Site
    autoload :Page

    mattr_accessor :site

    def self.draw(&block)
      return if migrating?
      return unless ActiveRecord::Base.connection.table_exists?(SeoTools::Page.table_name)

      self.site = Skeleton::Site.new
      # Evaluate the configuration block
      site.instance_exec(&block)

      # Save all the pages to database
      site.pages.each do |page|
        page.model.save!
      end

      # Delete pages not in skeleton
      destroy_deleted_pages!
    end

    def self.migrating?
      ActiveRecord::Migrator.needs_migration?
    end

    def self.destroy_deleted_pages!
      identifiers = site.pages.map(&:identifier)
      pages = SeoTools::Page.where.not(identifier: identifiers)

      if (count = pages.count) > 0
        Rails.logger.info("Destroying #{ count } removed pages from Skeleton")
        pages.destroy_all
      end
    end      
  end
end
