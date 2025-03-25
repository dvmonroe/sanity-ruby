# frozen_string_literal: true

# Hash#except! was added in Ruby 3
using Sanity::Refinements::Hashes if RUBY_VERSION.to_i < 3.0

module Sanity
  module Http
    class Where
      include Sanity::Http::Query
      delegate where_api_endpoint: :resource_klass
      alias_method :api_endpoint, :where_api_endpoint

      attr_reader :groq, :use_post, :groq_attributes, :variables, :perspective

      def initialize(**args)
        super
        @groq = args.delete(:groq) || ""
        @variables = args.delete(:variables) || {}
        @use_post = args.delete(:use_post) || false
        @perspective = args.delete(:perspective)

        @groq_attributes = args.except(
          :groq, :use_post, :resource_klass, :serializer, :result_wrapper, :perspective
        )
      end

      private

      def method
        use_post ? :post : :get
      end

      def uri
        super.tap do |obj|
          if use_post
            if perspective
              obj.query = URI.encode_www_form(perspective: perspective)
            end
          else
            obj.query = URI.encode_www_form(query_and_variables.merge({perspective: perspective}.compact))
          end
        end
      end

      def query_and_variables
        if use_post
          {params: variables}
        else
          {}.tap do |hash|
            variables.each do |key, value|
              hash["$#{key}"] = serialize_variable_value(value)
            end
          end
        end.merge(query: groq_query)
      end

      def groq_query
        groq.empty? ? Sanity::Groqify.call(**groq_attributes) : groq
      end

      def request_body
        return unless use_post

        query_and_variables.to_json
      end

      def serialize_variable_value(value)
        case value
        when String
          "\"#{value}\""
        when Array, Hash
          value.to_json
        else
          value.to_s
        end
      end
    end
  end
end
