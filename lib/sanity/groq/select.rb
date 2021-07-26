# frozen_string_literal: true

using Sanity::Refinements::Arrays

module Sanity
  module Groq
    class Select
      class << self
        def call(**args)
          new(**args).call
        end
      end

      RESERVED = %i[select]

      attr_reader :select, :val

      def initialize(**args)
        args.slice(*RESERVED).then do |opts|
          @select = opts[:select]
        end

        @val = +""
      end

      def call
        return unless select

        Array.wrap(select).each_with_index do |x, idx|
          val << "#{idx.positive? ? "," : ""} #{x}"
        end

        "{ #{val.strip} }"
      end
    end
  end
end
