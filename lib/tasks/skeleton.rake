namespace :seo_tools do
  namespace :skeleton do
    desc "Builds or refreshes the app skeleton."
    task build: :environment do
      Para::SeoTools::Skeleton.load
      Para::SeoTools::Skeleton::Worker.perform
    end
  end
end
