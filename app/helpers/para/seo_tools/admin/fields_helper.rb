module Para
  module SeoTools
    module Admin
      module FieldsHelper
        def meta_tag_input(form, name, options = {})
          options[:hint] ||= if (default = form.object.default(name))
            t('para.seo_tools.pages.default_meta_tag_value', value: default).html_safe
          end

          form.input name, options
        end
      end
    end
  end
end
