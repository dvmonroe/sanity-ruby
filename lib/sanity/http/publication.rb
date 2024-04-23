# frozen_string_literal: true

using Sanity::Refinements::Strings
using Sanity::Refinements::Arrays

module Sanity
  module Http
    module Publication
      class << self
        def included(base)
          base.extend(ClassMethods)
          base.extend(Forwardable)
          base.delegate(%i[project_id dataset token] => :"Sanity.config")
        end
      end

      module ClassMethods
        def call(args)
          new(args).call
        end
      end

      attr_reader :args

      def initialize(args)
        unless args.is_a?(String) || args.is_a?(Array)
          raise ArgumentError, "args must be a string or an array"
        end
        @args = Array.wrap(args)
      end

      def body_key
        "documentId"
      end

      def call
        Net::HTTP.post(uri, body.to_json, headers).then do |result|
          block_given? ? yield(result) : result
        end
      end

      def publication_path
        self.class.name.demodulize.underscore.camelize_lower
      end

      private

      def base_url
        "https://api.sanity.io/v1/#{publication_path}/#{project_id}/#{dataset}"
      end

      def body
        Array.wrap(args.map { |arg| {"#{body_key}": arg} })
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
