module SeoTools
  class SkeletonComponent < Para::Component::Crud
    register :seo_tools_skeleton, self

    def model_type
      '::SeoTools::Page'
    end
  end
end
