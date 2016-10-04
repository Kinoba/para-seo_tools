# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'para/seo_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "para-seo_tools"
  spec.version       = Para::SeoTools::VERSION
  spec.authors       = ["Valentin Ballestrino"]
  spec.email         = ["vala@glyph.fr"]
  spec.summary       = %q{SEO tools for the Para CMS}
  spec.description   = %q{SEO tools for the Para CMS}
  spec.homepage      = "https://github.com/para-cms/para"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rails', '>= 4.0', '< 5.0'
  spec.add_dependency 'sitemap_generator'
  spec.add_dependency 'request_store'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
