# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

require "sanity/http/result_wrapper"

using Sanity::Refinements::Strings
using Sanity::Refinements::Arrays

module Sanity
  module Http
    module Mutation
      class << self
        def included(base)
          base.extend(ClassMethods)
          base.extend(Forwardable)
          base.delegate(%i[project_id api_version dataset token] => :"Sanity.config")
          base.delegate(mutatable_api_endpoint: :resource_klass)
        end
      end

      module ClassMethods
        def call(**args)
          new(**args).call
        end
      end

      # See https://www.sanity.io/docs/http-mutations#visibility-937bc4250c79
      ALLOWED_VISIBILITY = %i[sync async deferred]

      # Default result wrapper if not provided
      # It must respond to the class method `.call` and expect
      # a single argument of the Net::HTTP response
      DEFAULT_RESULT_WRAPPER = Sanity::Http::ResultWrapper

      # See https://www.sanity.io/docs/http-mutations#aa493b1c2524
      REQUEST_KEY = "mutations"

      # See https://www.sanity.io/docs/http-mutations#952b77deb110
      DEFAULT_QUERY_PARAMS = {
        return_ids: false,
        return_documents: false,
        visibility: :sync
      }.freeze

      attr_reader :options, :params, :resource_klass, :query_set, :result_wrapper

      def initialize(**args)
        @resource_klass = args.delete(:resource_klass)
        @params = args.delete(:params)
        @query_set = Set.new
        @result_wrapper = args.delete(:result_wrapper) || DEFAULT_RESULT_WRAPPER

        raise ArgumentError, "resource_klass must be defined" unless resource_klass
        raise ArgumentError, "params argument is missing" unless params

        (args.delete(:options) || {}).then do |opts|
          DEFAULT_QUERY_PARAMS.keys.each do |qup|
            query_set << [qup, opts.fetch(qup, DEFAULT_QUERY_PARAMS[qup])]
          end
        end
        raise ArgumentError, "visibility argument must be one of #{ALLOWED_VISIBILITY}" unless valid_invisibility?
      end

      def call
        Net::HTTP.post(uri, {"#{REQUEST_KEY}": body}.to_json, headers).then do |result|
          block_given? ? yield(result_wrapper.call(result)) : result_wrapper.call(result)
        end
      end

      private

      def base_url
        "https://#{project_id}.api.sanity.io/#{api_version}/#{mutatable_api_endpoint}/#{dataset}"
      end

      def body
        return Array.wrap({"#{body_key}": params}) if params.is_a?(Hash)

        Array.wrap(params.map { |pam| {"#{body_key}": pam} })
      end

      def body_key
        self.class.name.demodulize.camelize(:lower)
      end

      def camelize_query_set
        query_set.to_h.transform_keys do |key|
          key.to_s.camelize_lower
        end
      end

      def headers
        {
          "Content-Type": "application/json",
          Authorization: "Bearer #{token}"
        }
      end

      def query_params
        camelize_query_set.map do |key, val|
          "#{key}=#{val}"
        end.join("&")
      end

      def uri
        URI("#{base_url}?#{query_params}")
      end

      def valid_invisibility?
        ALLOWED_VISIBILITY.include? query_set.to_h[:visibility]
      end
    end
  end
end
