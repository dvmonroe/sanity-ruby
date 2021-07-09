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

      attr_reader :args, :return_value

      def initialize(**args)
        @args = args
        @return_value = +""
      end

      def call
        opts = args.except(*Sanity::Groqify::RESERVED - RESERVED)

        if opts.include?(:select)
          Array.wrap(opts[:select]).each_with_index do |x, idx|
            return_value << "#{idx.positive? ? "," : ""} #{x}"
          end
          "{#{return_value.strip}}"
        end
      end
    end
  end
end
