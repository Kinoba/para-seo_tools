module Para
  module SeoTools
    class Routes < Para::Plugins::Routes
      def draw
        plugin :seo_tools do
          crud_component :skeleton, scope: ':model'
        end
      end
    end
  end
end
