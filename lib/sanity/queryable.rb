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
  module Queryable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      DEFAULT_KLASS_QUERIES = %i(find where).freeze

      private

      # @private
      def queryable(**options)
        options.fetch(:only, DEFAULT_KLASS_QUERIES).each do |query|
          define_singleton_method(query) do |*args|
            "Sanity::Http::#{query.to_s.classify}".constantize.call(*args)
          end
        end
      end
    end
  end
end
