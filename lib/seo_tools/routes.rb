module SeoTools
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw
      router.instance_eval do
        namespace :admin do
          namespace :seo_tools do
            component :skeleton do
              scope ':model' do
                resources :crud_resources, path: '/'
              end
            end
          end
        end
      end
    end
  end
end
