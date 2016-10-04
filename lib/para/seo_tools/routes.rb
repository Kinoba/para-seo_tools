module Para
  module SeoTools
    class Routes < Para::Plugins::Routes
      def draw
        plugin :seo_tools do
          crud_component :seo_tools_skeleton, scope: ':model', controller: :skeleton_resources

          namespace :admin do
            resource :skeleton_refresh, only: [:show] do
              get 'run'
              get 'ping'
            end
          end
        end
      end
    end
  end
end
