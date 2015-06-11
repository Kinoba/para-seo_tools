# SeoTools::Para

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

The go to the admin panel, and click the **Sitemap** menu link.

### 3. Generate a sitemap.xml

Sitemap generation is accomplished through the use of the
[rails-sitemap](https://github.com/viseztrance/rails-sitemap) gem,
with a custom task to integrate easily with `seo_tools-para`.

You'll first need to configure your application's host name.
This can be defined in the generated initializer or in an environment variable.

In the `config/initializers/seo_tools.rb` initializer :

```ruby
config.host = "www.mydomain.com"
```

Or with the `APP_DOMAIN` environment variable.

```bash
APP_DOMAIN="www.mydomain.com"
```

Generating the sitemap can be done with the dedicated rake task :

```bash
rake seo_tools:sitemap:generate
```

You can pass a `LOCATION` environment variable to define where to store it.
By default, it will be stored at : `public/sitemap.xml`

```bash
rake seo_tools:sitemap:generate LOCATION=/home/user/apps/my-app/shared
```

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
