# frozen_string_literal: true

require "forwardable"
require "net/http"
require "uri"
require "json"

module Sanity
  module Http
    module Mutation
      extend Forwardable
      def_delegators :"Sanity.config", :project_id, :api_version, :dataset, :token

      class << self
        def included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def call(**args)
          new(**args).call
        end
      end

      REQUEST_KEY = "mutations".freeze
      QUERY_PARAMS = {
        return_ids: false,
        return_documents: false,
        visibility: :sync,
      }.freeze

      attr_reader :options, :params, :resource_klass, :query_set

      def initialize(**args)
        @resource_klass = args.delete(:resource_klass)
        @params = args.delete(:params)
        @query_set = Set.new

        # raise Sanity::Http::MissingResource, "" unless resource_klass
        # raise Sanity::Http::MissingParams, "" unless params

        (args.delete(:options) || {}).then do |opts|
          QUERY_PARAMS.keys.each do |qup|
            query_set << [qup, opts.fetch(qup, QUERY_PARAMS[qup])]
          end
        end
      end

      def call
        Net::HTTP.post(uri, { "#{REQUEST_KEY}": body }.to_json, headers).then do |result|
          block_given? ? yield(result) : result
        end
      end

      private

      def base_url
        "https://#{project_id}.api.sanity.io/#{api_version}/data/mutate/#{dataset}"
      end

      def body
        case params
        when Array
          Array.wrap(params.map { |pam| { "#{body_key}": pam } })
        when Hash
          Array.wrap({ "#{body_key}": params })
        else
          []
        end
      end

      def body_key
        self.class.name.demodulize.underscore
      end

      def headers
        {
          "Content-Type": "application/json",
          "Authorization": "Bearer #{token}"
        }
      end

      def query_params
        query_set.to_h.flat_map do |key, val|
          "#{key.to_s.camelize(:lower)}=#{val}"
        end.join("&")
      end

      def uri
        URI("#{base_url}?#{query_params}")
      end
    end
  end
end
