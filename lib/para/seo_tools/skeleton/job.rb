module Para
  module SeoTools
    module Skeleton
      class Job < Para::Job::Base
        def perform
          Para::SeoTools::Skeleton.build(load_skeleton: true)
          Para::SeoTools::Sitemap.generate!
        end
      end
    end
  end
end
