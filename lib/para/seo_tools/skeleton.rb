module Para
  module SeoTools
    module Skeleton
      extend ActiveSupport::Autoload

      autoload :Site
      autoload :Page

      mattr_accessor :site

      def self.draw(&block)
        return unless ActiveRecord::Base.connection.table_exists?(
          Para::SeoTools::Page.table_name
        )

        self.site = Skeleton::Site.new
        # Evaluate the configuration block
        site.instance_exec(&block)
        # Save all the pages to database
        site.pages.each do |page|
          page.model.save!
        end
      end
    end
  end
end
