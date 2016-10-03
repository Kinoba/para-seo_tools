module Para
  module SeoTools
    module Skeleton
      extend ActiveSupport::Autoload

      autoload :Site
      autoload :PageBuilder
      autoload :Worker

      mattr_accessor :site, :config, :options, :enable_logging

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

      def self.draw(lazy: false, **options, &block)
        self.config = block
        self.options = options
        build unless lazy
      end

      def self.build(load_skeleton: false)
        return if migrating?
        return unless ActiveRecord::Base.connection.table_exists?(Para::SeoTools::Page.table_name)

        load if load_skeleton

        log "   * Building app skeleton pages ..."

        site_options = options.merge(enable_logging: enable_logging)
        self.site = Skeleton::Site.new(site_options)

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
