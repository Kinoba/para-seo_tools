module Para
  module SeoTools
    module SearchConsole
      extend ActiveSupport::Autoload

      autoload :BaseFetcher
      autoload :AnalyticsFetcher
      autoload :RefreshJob
    end
  end
end
