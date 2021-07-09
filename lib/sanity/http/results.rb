# frozen_string_literal: true

module Sanity
  module Http
    class Results
      class << self
        def call(result)
          new(result).call
        end
      end

      attr_reader :raw_result

      def initialize(result)
        @raw_result = result
      end

      def call
        raw_result
      end
    end
  end
end
