SeoTools::Skeleton.draw do
  # Define your website SEO targetted structure here.
  # Pages are defined with the `page` method, and allows for some options.
  #
  # The following will define the page `posts` and call `posts_path` to retrieve
  # its URL
  #
  #   page :posts
  #
  # If you want to define the page path yourself, just add the `:path` option
  # to the `page` call
  #
  #   page :home, path: root_path
  #
  # When the page is linked to a resource : often, a #show page, you'll need to
  # pass the `:resource` option
  #
  #   Posts.find_each do |post|
  #     page :post, resource: post
  #   end
  #
  # Also, you can pass options for the sitemap generation tool.
  # The options are `:priority`, `:change_frequency` which are left blank
  # by default.
  #
  #   page :posts, priority: 1, change_frequency: 'weekly'
  #
end
