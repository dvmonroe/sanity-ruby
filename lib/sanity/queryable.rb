# frozen_string_literal: true

module Sanity
  module Queryable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      DEFAULT_KLASS_QUERIES = %i(find where).freeze

      private

      def queryable(**options)
        options.fetch(:only, DEFAULT_KLASS_QUERIES).each do |query|
          define_singleton_method(query) do |*args|
            Module.const_get("Sanity::Http::#{query.to_s.classify}").call(*args)
          end
        end
      end
    end
  end
end
