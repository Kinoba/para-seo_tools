module Para
  module SeoTools
    module SearchConsole
      class RefreshJob < Para::Job::Base
        def perform
          fetcher = Para::SeoTools::SearchConsole::AnalyticsFetcher.new
          fetcher.refresh
        end
      end
    end
  end
end
