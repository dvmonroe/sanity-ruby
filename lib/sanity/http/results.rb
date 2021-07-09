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

      # TODO: parse the JSON and return what the user asked for
      # whether that just be the response, the document ids, or the
      # the document object(s) the user mutated
      def call
        raw_result
      end
    end
  end
end
