# frozen_string_literal: true

module Sanity
  module Http
    class Unpublish
      include Sanity::Http::Mutation

      def body_key
        "documentId"
      end

      def call
        Net::HTTP.post(uri, body.to_json, headers).then do |result|
          block_given? ? yield(serializer.call(result)) : serializer.call(result)
        end
      end

      protected

      def base_url
        "https://api.sanity.io/v1/unpublish/#{project_id}/#{dataset}"
      end
    end
  end
end
