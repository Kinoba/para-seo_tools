module Para
  module SeoTools
    class Routes < Para::Plugins::Routes
      def draw
        plugin :seo_tools do
          crud_component :seo_tools_skeleton, scope: ':model', controller: :skeleton_resources do
            collection do
              get :refresh
            end
          end
        end
      end
    end
  end
end
