module Para
  module SeoTools
    module Admin
      class SkeletonRefreshesController < ::Para::Admin::JobsController
        def run
          job = Para::SeoTools::Skeleton::Job.perform_later

          track_job(job)
        end
      end
    end
  end
end
