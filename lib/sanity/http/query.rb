# frozen_string_literal: true

require "cgi"

using Sanity::Refinements::Strings

module Sanity
  module Http
    module Query
      class << self
        def included(base)
          base.extend(ClassMethods)
          base.extend(Forwardable)
          base.delegate(%i[project_id api_version dataset token api_subdomain] => :"Sanity.config")
        end
      end

      module ClassMethods
        def call(**args)
          new(**args).call
        end
      end

      attr_reader :resource_klass, :serializer

      # @todo Add query support
      def initialize(**args)
        @resource_klass = args.delete(:resource_klass)

        warn RESULT_WRAPPER_DEPRECATION_WARNING if args[:result_wrapper]
        @serializer = args.delete(:serializer) ||
          args.delete(:result_wrapper) || # kept for backwards compatibility
          klass_serializer ||
          Sanity::Http::Results
      end

      # @todo Add query support
      def call
        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = uri.scheme == "https"

        request = Module.const_get("Net::HTTP::#{method.to_s.classify}").new(uri, headers)

        request.body = request_body

        http.request(request).then do |result|
          data = JSON.parse(result.body)

          block_given? ? yield(serializer.call(data)) : serializer.call(data)
        end
      end

      def result_wrapper
        warn RESULT_WRAPPER_DEPRECATION_WARNING
        serializer
      end

      private

      def request_body
      end

      def method
        :get
      end

      def base_url
        "https://#{project_id}.#{api_subdomain}.sanity.io/#{api_version}/#{api_endpoint}/#{dataset}"
      end

      def headers
        {
          "Content-Type": "application/json",
          Authorization: "Bearer #{token}"
        }
      end

      def klass_serializer
        return unless @resource_klass.respond_to?(:default_serializer)

        @resource_klass.default_serializer
      end

      def uri
        URI(base_url)
      end
    end
  end
end
