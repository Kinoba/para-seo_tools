# Use `lazy: true` to avoid generating the pages skeleton on server run
#
# You'll then have to run `rake para:seo_tools:skeleton:build` to refresh it or
# use the `Para::SeoTools::Skeleton::Job.perform` method in some worker to
# refresh it periodically
#
# Note that you also have to always refresh the sitemap manually with the
# following task : `rake para:seo_tools:sitemap:generate`
#
Para::SeoTools::Skeleton.draw(lazy: false) do
  # Define your website SEO targetted structure here.
  # Pages are defined with the `page` method, and allows for some options.
  #
  # The following will define the page `posts` and call `posts_path` to retrieve
  # its URL
  #
  #   page :posts
  #
  #
  # If you want to define the page path yourself, just add the `:path` option
  # to the `page` call
  #
  #   page :home, path: root_path
  #
  #
  # When the page is linked to a resource : often, a #show page, you'll need to
  # pass the `:resource` option
  #
  #   Posts.find_each do |post|
  #     page :post, resource: post
  #   end
  #
  #
  # Also, you can pass options for the sitemap generation tool.
  # The options are `:priority`, `:change_frequency` which are left blank
  # by default.
  #
  #   page :posts, priority: 1, change_frequency: 'weekly'
  #
  #
  # By default, when you pass a resource to a route, it will try to find
  # default a title and description from your resource, using the method
  # configured in the seo_tools.rb initializer at `config.title_methods` and
  # `config.description_methods`.
  #
  # For non-resource pages or if you need to add your own defaults, you can
  # pass them to the `#page` method the following way :
  #
  #   page :posts, defaults: { title: 'Blog index', description: 'Read our blog ...' }
  #   page :post, resource: post, defaults: { description: post.excerpt }
  #
  #
  # By default, every page that is not referenced in the skeleton will not be
  # indexed by search engines.
  #
  # But if some of your skeleton pages shouldn't be
  # indexed or links shouldn't be followed on that page, you can explicitly pass
  # the `:noindex` and `:nofollow` options to the `#page` method.
  #
  # It allows to let the admins edit the page title but avoids it to be indexed.
  #
  #   page :posts, noindex: true
  #   page :report_abuse, noindex: true, nofollow: true
  #
end
