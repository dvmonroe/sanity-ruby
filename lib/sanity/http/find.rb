# frozen_string_literal: true

module Sanity
  module Http
    class Find
      include Sanity::Http::Query
      delegate :find_api_endpoint, to: :resource_klass

      private

      def base_url
        "https://#{project_id}.api.sanity.io/#{api_version}/#{find_api_endpoint}/#{dataset}"
      end
    end
  end
end
