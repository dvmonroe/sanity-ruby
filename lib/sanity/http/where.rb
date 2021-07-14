# frozen_string_literal: true

# Hash#except! was added in Ruby 3
using Sanity::Refinements::Hashes if RUBY_VERSION.to_i < 3.0

module Sanity
  module Http
    class Where
      include Sanity::Http::Query
      delegate where_api_endpoint: :resource_klass
      alias_method :api_endpoint, :where_api_endpoint

      attr_reader :groq, :use_post, :groq_attributes

      def initialize(**args)
        super
        @groq = args.delete(:groq) || ""
        @use_post = args.delete(:use_post) || false

        @groq_attributes = args.except(:groq, :use_post, :resource_klass, :result_wrapper)
      end

      private

      def method
        use_post ? :post : :get
      end

      def uri
        super.tap do |obj|
          obj.query = "query=#{CGI.escape(groq_query)}"
        end
      end

      def groq_query
        groq.empty? ? Sanity::Groqify.call(**groq_attributes) : groq
      end
    end
  end
end
