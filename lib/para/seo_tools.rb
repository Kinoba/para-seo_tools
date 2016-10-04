require 'sitemap_generator'
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
    autoload :SitemapPinger
    autoload :PageScoping

    autoload :MetaTaggable
    autoload :MetaTaggableMacro
    autoload :ViewHelpers

    mattr_writer :host
    @@host = nil

    mattr_accessor :protocol
    @@protocol = :http

    mattr_accessor :handle_domain
    @@handle_domain = false

    mattr_accessor :handle_subdomain
    @@handle_subdomain = false

    mattr_accessor :default_subdomain
    @@default_subdomain = nil

    mattr_accessor :title_methods
    @@title_methods = %w(title name)

    mattr_accessor :description_methods
    @@description_methods = %w(description desc content)

    mattr_accessor :image_methods
    @@image_methods = %w(image picture avatar)

    mattr_accessor :defaults
    @@defaults = nil

    mattr_accessor :generate_hreflang_tags
    @@generate_hreflang_tags = false

    def self.configure
      block_given? ? yield(self) : self
    end

    def self.table_name_prefix
      'seo_tools_'
    end

    def self.host
      @@host ||= ENV['APP_DOMAIN']
    end

    def self.full_host
      host = [Para::SeoTools.default_subdomain, Para::SeoTools.host].compact.join(',')
      [Para::SeoTools.protocol, host].join('://')
    end
  end
end
