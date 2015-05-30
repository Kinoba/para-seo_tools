module SeoTools
  module Skeleton
    extend ActiveSupport::Autoload

    autoload :Site
    autoload :Page

    mattr_accessor :site

    def self.draw(&block)
      self.site = Skeleton::Site.new
      site.instance_exec(&block)
    end
  end
end
