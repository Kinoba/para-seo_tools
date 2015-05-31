require 'sitemap'

module SeoTools
  extend ActiveSupport::Autoload

  autoload :Skeleton
  autoload :Sitemap

  mattr_accessor :host
  @@host = ENV['APP_DOMAIN']
end

require 'seo_tools/railtie'
