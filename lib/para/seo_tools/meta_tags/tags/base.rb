module Para
  module SeoTools
    module MetaTags
      module Tags
        class Base
          attr_accessor :controller

          def initialize(controller)
            @controller = controller
          end

          # Overriding this method in subclasses allow to process the meta tag
          # value before it is rendered, e.g. stripping HTML tags
          #
          def self.process(value)
            value
          end

          protected

          def member_action?
            controller.params.key?(:id)
          end

          def action_i18n(label)
            I18n.t(action_key(label), default: '').presence
          end

          def action_key(label)
            key = %w(meta_tags controller)
            key << controller.params[:controller]
            key << controller.params[:action]
            key << label
            key.join(".")
          end

          # TODO : Define if we'll still support resource meta tags and refactor
          #        accordingly
          def resource
          end

          def model_name
            @model_name ||= controller.class.name.gsub(/Controller$/, '').singularize.underscore
          end
        end
      end
    end
  end
end
