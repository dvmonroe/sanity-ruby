# frozen_string_literal: true

module Sanity
  module Groq
    class Slice
      class << self
        def call(**args)
          new(**args).call
        end
      end

      RESERVED = %i[limit offset]
      ZERO_INDEX = 0

      attr_reader :limit, :offset

      def initialize(**args)
        args.slice(*RESERVED).then do |opts|
          @limit = opts[:limit]
          @offset = opts[:offset]
        end
      end

      def call
        return "" unless limit

        !offset ? zero_index_to_limit : offset_to_limit
      end

      private

      def offset_to_limit
        "[#{offset}...#{limit + offset}]"
      end

      def zero_index_to_limit
        "[#{ZERO_INDEX}...#{limit}]"
      end
    end
  end
end
