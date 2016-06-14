module Para
  module SeoTools
    class Page < ActiveRecord::Base
      META_TAGS = :title, :description, :keywords, :image, :canonical

      has_attached_file :image, styles: { thumb: '200x200#' }
      validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }

      def meta_tag(name)
        process(name, send(name)).presence || default(name)
      end

      def defaults
        if (hash = read_attribute(:defaults))
          hash
        else
          self.defaults = {}
        end
      end

      def default(name)
        process(name, defaults[name.to_s]) if defaults[name.to_s]
      end

      ransacker :title do |parent|
        default_title = Arel::Nodes::InfixOperation.new('->>', parent.table[:defaults], Arel::Nodes.build_quoted('title'))
        expr = Arel::Nodes::NamedFunction.new('COALESCE', [parent.table[:title], default_title])

        # Conversion to Arel::Nodes::SqlLiteral is required for sorting to work,
        # since the Arel::Nodes::NamedFunction doesn't include Arel ordering
        # methods, and Ransack uses them
        #
        Arel::Nodes::SqlLiteral.new(expr.to_sql)
      end

      ransacker :description do |parent|
        default_description = Arel::Nodes::InfixOperation.new('->>', parent.table[:defaults], Arel::Nodes.build_quoted('description'))
        expr = Arel::Nodes::NamedFunction.new('COALESCE',[parent.table[:description], default_description])

        Arel::Nodes::SqlLiteral.new(expr.to_sql)
      end

      private

      def process(name, value)
        if (processor = Para::SeoTools::MetaTags::Tags[name])
          processor.process(value)
        else
          value
        end
      end
    end
  end
end
