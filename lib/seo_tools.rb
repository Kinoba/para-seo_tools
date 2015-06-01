require 'sitemap'
require 'meta_tags'

module SeoTools
  extend ActiveSupport::Autoload

  autoload :Skeleton
  autoload :Sitemap
  autoload :MetaTags

  mattr_accessor :host
  @@host = ENV['APP_DOMAIN']
end

require 'seo_tools/railtie'
