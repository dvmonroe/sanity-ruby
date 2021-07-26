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
          base.delegate(%i[project_id api_version dataset token] => :"Sanity.config")
        end
      end

      module ClassMethods
        def call(**args)
          new(**args).call
        end
      end

      attr_reader :resource_klass, :result_wrapper

      # @todo Add query support
      def initialize(**args)
        @resource_klass = args.delete(:resource_klass)
        @result_wrapper = args.delete(:result_wrapper) || Sanity::Http::Results
      end

      # @todo Add query support
      def call
        http = Net::HTTP.new(uri.host, uri.port)

        http.use_ssl = uri.scheme == "https"

        request = Module.const_get("Net::HTTP::#{method.to_s.classify}").new(uri, headers)

        request.body = request_body

        http.request(request).then do |result|
          data = JSON.parse(result.body)

          block_given? ? yield(result_wrapper.call(data)) : result_wrapper.call(data)
        end
      end

      private

      def request_body
      end

      def method
        :get
      end

      def base_url
        "https://#{project_id}.api.sanity.io/#{api_version}/#{api_endpoint}/#{dataset}"
      end

      def headers
        {
          "Content-Type": "application/json",
          Authorization: "Bearer #{token}"
        }
      end

      def uri
        URI(base_url)
      end
    end
  end
end
