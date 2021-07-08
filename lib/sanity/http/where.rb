# frozen_string_literal: true

module Sanity
  module Http
    class Where
      include Sanity::Http::Query
      delegate where_api_endpoint: :resource_klass
      alias_method :api_endpoint, :where_api_endpoint

      attr_reader :groq, :use_post

      def initialize(**args)
        super
        @groq = args.delete(:groq) || false
        @use_post = args.delete(:use_post) || false
      end

      private

      def method
        use_post ? :post : :get
      end

      def url
        "#{base_url}?query=#{}"
      end
    end
  end
end
