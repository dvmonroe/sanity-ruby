# frozen_string_literal: true

module Sanity
  module Http
    class Publish
      include Sanity::Http::Mutation

      def call
        Net::HTTP.post(uri, body.to_json, headers).then do |result|
          block_given? ? yield(serializer.call(result)) : serializer.call(result)
        end
      end

      private

      def base_url
        "https://api.sanity.io/v1/publish/#{project_id}/#{dataset}"
      end

      def body_key
        "documentId"
      end
    end
  end
end
