module Para
  module SeoTools
    module Skeleton
      extend ActiveSupport::Autoload

      autoload :Site
      autoload :Page
      autoload :Worker

      mattr_accessor :site, :config, :enable_logging

      def self.with_logging(&block)
        self.enable_logging = true
        block.call
      ensure
        self.enable_logging = false
      end

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

        log "   * Building app skeleton pages ..."

        self.site = Skeleton::Site.new(enable_logging: enable_logging)
        # Evaluate the configuration block
        site.instance_exec(&config)

        # Save remaining pages and remove old pages
        ActiveRecord::Base.transaction do
          site.save

          # Delete pages not in skeleton
          destroy_deleted_pages!
        end
      end

      def self.migrating?
        ActiveRecord::Migrator.needs_migration?
      end

      def self.destroy_deleted_pages!
        pages = Para::SeoTools::Page.where.not(id: site.saved_pages_ids)
        log "   * Destroying old pages ..."
        pages.delete_all
      end

      # Log messages when you're not in rails
      #
      def self.log(message)
        Rails.logger.info(message) if enable_logging || !$0.end_with?('rails')
      end
    end
  end
end
