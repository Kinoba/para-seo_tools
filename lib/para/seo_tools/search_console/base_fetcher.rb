module Para
  module SeoTools
    module SearchConsole
      class BaseFetcher
        include HTTParty

        base_uri 'https://www.googleapis.com/webmasters/v3/sites'

        attr_reader :access_token

        def initialize
          ENV['GOOGLE_APPLICATION_CREDENTIALS'] = Rails.root.join('config/google-auth.json').to_s

          scopes =  [
            'https://www.googleapis.com/auth/webmasters.readonly',
            'https://www.googleapis.com/auth/webmasters'
          ]

          authorization = Google::Auth.get_application_default(scopes)
          authorization.fetch_access_token!

          @access_token = authorization.access_token
        end

        def get(path, options = {})
          self.class.get(with_site_url(path), options.reverse_merge(default_options))
        end

        def post(path, body: nil, **options)
          options = options.reverse_merge(default_options)
          options[:body] = body.to_json if Hash === body

          self.class.post(with_site_url(path), options)
        end

        protected

        def default_options
          {
            headers: {
              :authorization => "Bearer #{ access_token }",
              'Content-Type' => 'application/json'
            }
          }
        end

        def with_site_url(path)
          ['', site_url, path].join('/')
        end

        def site_url
          CGI.escape('http://molli.com')
        end
      end
    end
  end
end
