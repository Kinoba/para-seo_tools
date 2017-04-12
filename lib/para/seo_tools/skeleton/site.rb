module Para
  module SeoTools
    module Skeleton
      class Site
        include Rails.application.routes.url_helpers
        attr_reader :enable_logging, :default_page_options

        def initialize(options = {})
          @enable_logging = options.delete(:enable_logging)
          @default_page_options = options
        end

        def page(name, options = {}, &block)
          options.reverse_merge!(default_page_options)

          Skeleton::PageBuilder.new(name, options).tap do |page|
            pages << page
            save if pages.length == max_pages_before_save
          end
        end

        def with_params(params = {}, &block)
          previous_default_page_options = default_page_options
          @default_page_options = default_page_options.dup.merge(params)
          block.call
          @default_page_options = previous_default_page_options
        end

        def pages
          @pages ||= []
        end

        def save
          log "   * Saving #{ pages.length } generated pages ..."

          ActiveRecord::Base.transaction do
            pages.each do |page|
              page.model.save!
              saved_pages_ids << page.model.id
            end
          end

          pages.clear
        end

        def saved_pages_ids
          @saved_pages_ids ||= []
        end

        # Log messages when you're not in rails
        #
        def log(message)
          Rails.logger.info(message) if enable_logging || !$0.end_with?('rails')
        end

        def max_pages_before_save
          @max_pages_before_save ||= if (param = ENV['SEO_TOOLS_MAX_PAGES_BEFORE_SAVE']).present?
            para.to_i
          else
            500
          end
        end
      end
    end
  end
end
