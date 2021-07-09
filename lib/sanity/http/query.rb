# frozen_string_literal: true

require "cgi"

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
        Net::HTTP.send(method, uri, headers).then do |result|
          block_given? ? yield(result_wrapper.call(result)) : result_wrapper.call(result)
        end
      end

      private

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
