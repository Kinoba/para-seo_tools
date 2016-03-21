module Para
  module SeoTools
    module Skeleton
      extend ActiveSupport::Autoload

      autoload :Site
      autoload :Page
      autoload :Worker

      mattr_accessor :site, :config

      def self.load
        # Ensure routes are loaded to allow skeleton to call routes name helpers
        Rails.application.reload_routes!
        # Skeleton file path
        skeleton_path = Rails.root.join('config', 'skeleton.rb')
        # Load the skeleton file
        require skeleton_path if File.exists?(skeleton_path)
      end

      def self.draw(lazy: false, &block)
        self.config = block
        build unless lazy
      end

      def self.build
        return if migrating?
        return unless ActiveRecord::Base.connection.table_exists?(Para::SeoTools::Page.table_name)

        self.site = Skeleton::Site.new
        # Evaluate the configuration block
        site.instance_exec(&config)

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
        pages = Para::SeoTools::Page.where.not(identifier: identifiers)

        if (count = pages.count) > 0
          Rails.logger.info("Destroying #{ count } removed pages from Skeleton")
          pages.destroy_all
        end
      end
    end
  end
end
