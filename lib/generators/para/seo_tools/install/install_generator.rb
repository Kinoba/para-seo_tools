module Para
  module SeoTools
    class InstallGenerator < Rails::Generators::Base
      # Copied files come from templates folder
      source_root File.expand_path('../templates', __FILE__)

      # Generator desc
      desc 'Seo Tools install generator'

      def copy_initializer_file
        copy_file 'initializer.rb', 'config/initializers/seo_tools.rb'
      end

      def copy_and_run_migrations
        rake 'para_seo_tools_engine:install:migrations'
        rake 'db:migrate'
      end

      def create_skeleton_file
        copy_file 'skeleton.rb', 'config/skeleton.rb'
      end
    end
  end
end
