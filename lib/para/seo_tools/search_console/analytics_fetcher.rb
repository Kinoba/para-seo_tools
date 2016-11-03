module Para
  module SeoTools
    module SearchConsole
      class AnalyticsFetcher < BaseFetcher
        def refresh(options = {})
          start_date = options.fetch(:start_date, 10.days.ago)
          end_date = options.fetch(:end_date, Date.today)

          ActiveRecord::Base.transaction do
            (start_date.to_date..end_date.to_date).each do |date|
              refresh_at(date)
            end
          end
        end

        private

        def refresh_at(date)
          api_date = date.strftime('%Y-%m-%d')

          response = post 'searchAnalytics/query', body: {
            startDate: api_date,
            endDate: api_date,
            dimensions: ["page", "country", "query", "device"]
          }

          if (rows = JSON.parse(response.body)['rows'])
            rows.each do |row|
              update(row, date)
            end
          end
        end

        def update(data, date)
          page_url, country, query, device = data['keys']
          clicks, impressions, ctr, position = data.values_at('clicks', 'impressions', 'ctr', 'position')

          page = find_page_for(page_url)

          # Do not store analytics results for non-page URLs
          # This includes documents (.pdf, .doc) and other non-indexed pages
          # that should not be taken into account
          #
          # Note : This is a behavior that could be enhanced, since documents
          #        and other pages could be used to give some insights later
          #
          return unless page

          analytics_row = page.search_analytics_rows.where(
            country: country, query: query, device: device, date: date
          ).first_or_initialize

          analytics_row.assign_attributes(
            clicks: clicks,
            impressions: impressions,
            ctr: ctr,
            position: position,
            date: date
          )

          analytics_row.save!
        end

        def find_page_for(page_url)
          uri = URI.parse(page_url)

          scope = Para::SeoTools::Page.where(path: uri.path)

          if Para.config.seo_tools.handle_subdomain
            subdomain = uri.host.split('.')[0..-3].join('.')
            scope = scope.where(subdomain: subdomain)
          end

          if Para.config.seo_tools.handle_domain
            domain = uri.host.split('.')[-2..-1].join('.')
            scope = scope.where(domain: domain)
          end

          scope.first
        end
      end
    end
  end
end
