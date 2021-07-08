# frozen_string_literal: true

module Sanity
  module Http
    class Patch
      include Sanity::Http::Mutation

      # @todo Add patch support
      def call
        true
      end
    end
  end
end
