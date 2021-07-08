# frozen_string_literal: true

module Sanity
  module Http
    class Find
      include Sanity::Http::Query
      delegate find_api_endpoint: :resource_klass
      alias_method :api_endpoint, :find_api_endpoint

      attr_reader :id

      def initialize(**args)
        super
        @id = args.delete(:id)
      end

      private

      def url
        "#{base_url}/#{id}"
      end
    end
  end
end
