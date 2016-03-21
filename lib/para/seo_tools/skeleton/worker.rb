module Para
  module SeoTools
    module Skeleton
      class Worker
        def self.perform
          Para::SeoTools::Skeleton.build
        end
      end
    end
  end
end
