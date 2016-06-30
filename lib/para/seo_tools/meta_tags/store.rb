module Para
  module SeoTools
    module MetaTags
      class Store
        attr_reader :controller, :defaults

        TAGS = :title, :description, :image, :url, :site_name, :keywords, :type,
               :site, :card, :charset, :canonical

        attr_writer *TAGS

        def initialize(controller)
          @controller = controller

          @defaults = if Para::SeoTools.defaults
            controller.instance_exec(&Para::SeoTools.defaults)
          else
            {}
          end
        end

        def charset
          @charset ||= 'utf-8'
        end

        TAGS.each do |tag_name|
          define_method(tag_name) do
            fetch_value_for(tag_name)
          end unless method_defined?(tag_name)
        end

        private

        def fetch_value_for(tag_name)
          ivar_name = :"@#{ tag_name }"

          puts " ** fetch_value_for : #{ tag_name }"

          if (value = instance_variable_get(ivar_name)).present?
            puts " ** ivar_name present : #{ ivar_name } -- #{ value }"
            value
          else
            puts " ** process : #{ MetaTags::Tags[tag_name].inspect } -- #{ value }"

            value = if (processor = MetaTags::Tags[tag_name])
              processor.new(controller).value
            end

            puts " ** value processed : #{ value } -- default ? : #{ (defaults[tag_name] unless value.present?).inspect }"
            value = defaults[tag_name] unless value.present?

            instance_variable_set(ivar_name, value) if value
          end
        end
      end
    end
  end
end
