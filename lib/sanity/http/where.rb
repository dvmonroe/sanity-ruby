# frozen_string_literal: true

module Sanity
  module Http
    class Where
      include Sanity::Http::Query
      def_delegators :"resource_klass", :where_api_endpoint

      private

      def base_url
        "https://#{project_id}.api.sanity.io/#{api_version}/#{where_api_endpoint}/#{dataset}"
      end
    end
  end
end
