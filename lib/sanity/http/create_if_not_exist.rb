# frozen_string_literal: true

module Sanity
  module Http
    class CreateIfNotExist
      include Sanity::Http::Mutation

      private

      def body_key
        "createIfNotExists"
      end
    end
  end
end
