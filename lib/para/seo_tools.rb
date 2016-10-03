require 'sitemap'
require 'para'

require 'para/seo_tools/engine'

module Para
  module SeoTools
    extend ActiveSupport::Autoload

    autoload :Controller
    autoload :MetaTags
    autoload :Routes
    autoload :Skeleton
    autoload :Sitemap
    autoload :PageScoping

    autoload :MetaTaggable
    autoload :MetaTaggableMacro
    autoload :ViewHelpers

    mattr_writer :host
    @@host = ENV['APP_DOMAIN']

    mattr_accessor :handle_domain
    @@handle_domain = false

    mattr_accessor :handle_subdomain
    @@handle_subdomain = false

    mattr_accessor :title_methods
    @@title_methods = %w(title name)

    mattr_accessor :description_methods
    @@description_methods = %w(description desc content)

    mattr_accessor :image_methods
    @@image_methods = %w(image picture avatar)

    mattr_accessor :defaults
    @@defaults = nil

    def self.configure
      block_given? ? yield(self) : self
    end

    def self.table_name_prefix
      'seo_tools_'
    end

    def self.host
      @@host.presence && @@host.match(/[^:]+/)[0]
    end
  end
end
