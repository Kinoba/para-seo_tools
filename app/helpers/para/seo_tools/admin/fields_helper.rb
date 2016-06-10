module Para
  module SeoTools
    module Admin
      module FieldsHelper
        def meta_tag_input(form, name, options = {})
          options[:hint] ||= if !form.object.send(name) && (default = form.object.meta_tag(name))
            t('para.seo_tools.pages.default_meta_tag_value', value: default)
          end

          form.input name, options
        end
      end
    end
  end
end
