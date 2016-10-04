# Para::SeoTools

The SEO Tools for Para allows to configure the sitemap and meta tags for your
Para CMS powered website.

You'll be able to easily define a sitemap for your app, and get an admin panel
for filling out all the pages' meta tags.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seo_tools-para'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install seo_tools-para
```

Run the installation generator :

```bash
rails generate seo_tools:install
```

## Usage

The idea is to define a simple Sitemap structure, and you'll be able to
edit those pages meta_tags from the admin panel, and a sitemap.xml will be
generatable with a simple Task.

In the following section, you'll find how to :

1. Define the sitemap
2. Display the meta tags admin panel
3. Generate a sitemap.xml
4. Retrieving meta tags in your app


### 1. Define the sitemap

When you run the `seo_tools:install` generator, a file is created at
`config/skeleton.rb` for you to create the sitemap.

This file allows you to define which pages you want to make available for
search engines indexation and optimization, through a simple DSL.

The pages are defined with the `page` method, and accepts some options.

The following will define the page `posts` and call `posts_path` to retrieve
its URL

```ruby
page :posts
```

If you want to define the page path yourself, just add the `:path` option
to the `page` call

```ruby
page :home, path: root_path
```

When the page is linked to a resource : often, a #show page, you'll need to
pass the `:resource` option

```ruby
Posts.find_each do |post|
  page :post, resource: post
end
```

Also, you can pass options for the sitemap generation tool.
The options are `:priority`, `:change_frequency` which are left blank
by default.

```ruby
page :posts, priority: 1, change_frequency: 'weekly'
```

#### Default meta tag values

The `page` method allows to define default data for seo_tools to use as default
values for the title and description meta tags.

For example, using your post title as default meta title and its excerpt as the
default description meta tag value is as easy as :

```ruby
Posts.find_each do |post|
  page :post, resource: post, defaults: { title: post.title, description: post.excerpt }
end
```

#### Arbitrary scoping of pages

SeoTools ensures your page identifiers are unique. This avoids duplicating pages
and unwanted side effects. This identifier is generated with the first argument
of the `#page` method (`:post` in our examples), and the id of the resource
passed in the `:resource` argument, when present.

For a `:post` with id `25`, this results in an identifier containing :
`"post:25"`.

Sometimes you'll need to have multiple pages that allows accessing a single
resource, and your identifier would be duplicated. In this case, you can use
the `:scope` argument, which will allow to create multiple identifiers with
the same value, scoped to the given arguments.

As an example, you can this of posts belonging to multiple categories, which
would result in a structure where a post could appear under multiple categories.

To handle this case, we would write :

```ruby
Categories.each do |category|
  category.posts.each do |post|
    page :post, resource: post, path: category_post_path(category, post), scope: :category_id, category_id: post.category_id
  end
end
```

As a side effect, you can find all "sibling" pages of a given page, allowing
you to handle canonical URLs or HREFLANG meta tags with ease.

#### Batch scoping and params forwarding

When you have many pages scoped with the same parameters, you may want to DRY
out scope params passing to the `#page` method calls.

This can be accomplished with the `#with_params` helper method. When used,
every call to the `#page` method would automatically fetch params passed to the
`#with_params` method as default params to build or update the underlying page
object.

Below's an example of a situation where you would have a multi-store shop, and
want to scope all product categories and products pages depending on their
belonging store, given that some products and categories could exist in multiple
stores, requiring you to scope them.

```ruby
Stores.each do |store|
  with_params store_id: store.id, scope: :store_id do
    store.product_categories.each do |product_category|
      page :product_category, resource: product_category

      product_category.products.each do |product|
        page :product, resource: product
      end
    end
  end
end
```

Global skeleton-wide default params can also be passed to the
`Para::SeoTools::Skeleton.draw` call at the top of the skeleton file :

```ruby
Para::SeoTools::Skeleton.draw(scope: :store_id) do
  # You code scoped by store_id here
end
```

#### Locales support

SeoTools comes with multi-locale support built-in. By default, each call to the
`page` method assigns the current `I18n.locale` to the created page resource.

Localized page path handling is dependent on your app logic, but you can easily
generate pages for each locale.

If routing to a specific locale only needs a `:locale` argument passed to your
URL helpers, and you want to create a page for each available locale, here how
you'd do it :

```ruby
Para::SeoTools::Skeleton.draw(scope: :locale) do
  I18n.available_locales.each do |locale|
    I18n.with_locale(locale) do
      Posts.find_each do |post|
        page :post, resource: post, path: post_path(post, locale: locale)
      end
    end
  end
```

By using `I18n.with_locale`, we force the current locale in the block, and
SeoTools automatically assigns the locale to the page resource.

#### Lazy skeleton building.

On large applications, building the skeleton with all its pages at application
boot time is not an option. You can opt out from this strategy and choose to
build it yourself from a rake task by using the `Para::SeoTools::Skeleton.draw`
`:lazy` param and calling the rake task from a CRON or similar job.

```ruby
Para::SeoTools::Skeleton.draw(lazy: true) do
  # ...
end
```

Then use the following rake task :

```bash
rake seo_tools:skeleton:build
```

#### Domain and subdomains handling

By default, SeoTools doesn't handle specifically domains and subdomains, since
it stores the page paths with a leading `/`.

You can tell it to take those parameters into account when building the
skeleton, and when fetching data during the request.

The first step is to activate one or both of domain and subdomain handling, use
the `#handle_domain` and `#handle_subdomain` in the para initializer file :

```ruby
Para.config do |config|
  config.seo_tools do |seo_tools|
    seo_tools.handle_domain = true
    seo_tools.handle_subdomain = true
  end
end
```

Then, you need to pass the domain and subdomain as parameters of the `#page`
call of your skeleton.rb, or with batch params assignation as described above
[Batch scoping and params forwarding](#batch-scoping-and-params-forwarding)

```ruby
page :post, resource: post, subdomain: 'blog', domain: 'example.com'
```

Now, when the page data is fetched during the request, the `request.subdomain`
and `request.domain` will be used.


### 2. Display the meta tags admin panel

For the admin panel to display, all you'll need to do is create the component
in your Para's `components.rb`.

> Note : For more informations on the `components.rb` file, please see the
> [Para documentation](https://github.com/para-cms/para/wiki/Components-configuration)

Add the component to your `config/components.rb` file :

```ruby
section :your_section do
  component :sitemap, :seo_tools_skeleton
end
```

Then go to the admin panel, and click the **Sitemap** menu link.

### 3. Generate a sitemap.xml

Sitemap generation is accomplished through the use of the
[Sitemap Generator](https://github.com/kjvarga/sitemap_generator) gem,
with a custom task and interface to integrate easily with `seo_tools-para`.

You'll first need to configure your application's host name.
This can be defined in the generated initializer or in an environment variable.

In the `config/initializers/seo_tools.rb` initializer :

```ruby
config.host = 'www.mydomain.com'
```

Or with the `APP_DOMAIN` environment variable.

```bash
APP_DOMAIN="www.mydomain.com"
```

If you want to handle subdomains you need to set the `host` without a subdomain
and the `default_subdomain` configs together :

```ruby
config.host = 'mydomain.com'
config.default_subdomain = 'www'
```

Generating the sitemap can be done with the dedicated rake task :

```bash
rake para:seo_tools:sitemap:generate
```

For more customization informations, please read the
[Sitemap Generator](https://github.com/kjvarga/sitemap_generator) gem
documentation.

### 4. Retrieving meta tags in your app

Meta tags edition and rendering is done through the
[meta_tags](https://github.com/glyph-fr/meta_tags) gem.

For more informations on customizing its behavior, please see the
[meta_tags documentation](https://github.com/glyph-fr/meta_tags).

The meta tags are automatically retrieved from the current page path by default.

`seo_tools-para` includes a `before_action` callback that fetches the existing
meta tags for the current path, and sets them in your page.

All you need to do is to include the following in your layout file, at the top
of your `<head>` tag, since `meta_tags` automatically appends the
`<meta encoding="utf-8">` tag.

```erb
<html>
  <head>
    <%= meta_tags %>
    ...
  </head>
  <body>
    ...
  </body>
</html>
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/seo_tools-para/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
