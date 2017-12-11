module Para
  module SeoTools
    class Page < ActiveRecord::Base
      META_TAGS = :title, :description, :keywords, :image, :canonical

      store_accessor :config, :scope, :canonical

      has_attached_file :image, styles: { thumb: '200x200#' }
      validates_attachment :image, content_type: { content_type: /\Aimage\/.*\Z/ }

      validate :identifier_uniqueness

      scope :with_subdomain, ->(subdomain) { scope_with(subdomain: subdomain) }
      scope :with_domain, ->(domain) { scope_with(domain: domain) }
      scope :with_canonical, -> { where("config->>'canonical' IS NOT NULL") }

      scope :scope_with, ->(attributes) { PageScoping.scope_with(self, attributes) }

      def meta_tag(name)
        if (value = send(name).presence) && (meta = process(name, value)).present?
          return meta
        end

        default(name)
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

      ransacker :subdomain do |parent|
        expr = Arel::Nodes::InfixOperation.new('->>', parent.table[:config], Arel::Nodes.build_quoted('subdomain'))

        Arel::Nodes::SqlLiteral.new(expr.to_sql)
      end

      ransacker :canonical do |parent|
        expr = Arel::Nodes::InfixOperation.new('->>', parent.table[:config], Arel::Nodes.build_quoted('canonical'))

        Arel::Nodes::SqlLiteral.new(expr.to_sql)
      end

      def scope_attributes
        scope.each_with_object({}) do |attribute, hash|
          hash[attribute] = if self.class.column_names.include?(attribute.to_s)
            send(attribute)
          else
            config[attribute.to_s]
          end
        end
      end

      def url
        @url ||= [host, path].join
      end

      def host
        host = []

        if Para::SeoTools.handle_subdomain
          if (subdomain = config['subdomain'])
            host << subdomain
          else
            host << Para::SeoTools.default_domain
          end
        end

        if Para::SeoTools.handle_domain
          host << config['domain']
        else
          host << Para::SeoTools.host
        end

        host = host.compact.join('.')

        [Para::SeoTools.protocol, host].join('://')
      end

      def siblings
        self.class.where(identifier: identifier).where.not(id: id)
      end

      private

      def process(name, value)
        if (processor = Para::SeoTools::MetaTags::Tags[name])
          processor.process(value)
        else
          value
        end
      end

      def identifier_uniqueness
        conditions = PageScoping.new(self).uniqueness_scope_conditions
        conditions = conditions.where.not(id: id) if persisted?

        if conditions.where(identifier: identifier).exists?
          errors.add(:identifier, :taken)
        end
      end

      def self.available_subdomains
        select("DISTINCT(config->>'subdomain') AS subdomain").map do |page|
          page.read_attribute(:subdomain)
        end
      end

      def method_missing(method_name, *args, &block)
        if config.key?(method_name.to_s)
          config[method_name.to_s]
        else
          super
        end
      end
    end
  end
end
