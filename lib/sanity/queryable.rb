# frozen_string_literal: true

module Sanity
  # Queryable is responsible for setting the appropriate class methods
  # that invoke Sanity::Http's query classes
  #
  # The queryable marco can limit what queries are accessible to the
  # queryable object
  #
  # @example provides default class methods
  #   queryable
  #
  # @example only add the `.where` method
  #   queryable only: %i(where)
  #
  # @example only add the `.find` method
  #   queryable only: %i(find)
  #
  using Sanity::Refinements::Strings

  module Queryable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      DEFAULT_KLASS_QUERIES = %i[find where].freeze

      # See https://www.sanity.io/docs/http-query & https://www.sanity.io/docs/http-doc
      QUERY_ENDPOINTS = {
        find: "data/doc",
        where: "data/query"
      }.freeze

      private

      def queryable(**options)
        options.fetch(:only, DEFAULT_KLASS_QUERIES).each do |query|
          define_query_method(query)
        end
      end

      def define_query_method(query)
        define_singleton_method(query) do |**args|
          default_type = args.key?(:_type) ? args[:_type] : Sanity::TypeHelper.default_type(self)
          default_args = {resource_klass: self, _type: default_type}.compact
          Module.const_get("Sanity::Http::#{query.to_s.classify}").call(**default_args.merge(args))
        end
        define_singleton_method(:"#{query}_api_endpoint") { QUERY_ENDPOINTS[query] }
      end
    end
  end
end
