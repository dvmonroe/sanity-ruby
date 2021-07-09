# frozen_string_literal: true

module Sanity
  module Groq
    class Filter
      class << self
        def call(**args)
          new(**args).call
        end
      end

      OPERATORS = {
        is: "==",
        not: "!=",
        gt: ">",
        gt_eq: ">=",
        lt: "<",
        lt_eq: "<="
      }

      MULTIPLE = {
        and: "&&",
        or: "||"
      }

      TOP_LEVEL = {
        and: "&&",
        or: "||",
        not: "!"
      }

      WORDS = %i[match]

      RESERVED = TOP_LEVEL.keys | OPERATORS.keys | MULTIPLE.keys | WORDS

      attr_reader :args, :filter_value

      def initialize(**args)
        @args = args.except(*Sanity::Groqify::RESERVED - RESERVED)
        @filter_value = +""
      end

      def call
        iterate

        filter_value
      end

      private

      # TODO: Fix up
      def iterate
        args.each do |key, val|
          if val.is_a?(String)
            filter_value << "#{default_multi_filter} #{key} == '#{val}'".strip
          end

          if MULTIPLE.include?(key)
            if MULTIPLE.include?(val.keys[0])
              filter_value << "#{MULTIPLE[key]} ("

              val.values[0].each_with_index do |(vkey, vval), idx|
                filter_value << if idx.positive?
                  " #{MULTIPLE[val.keys[0]]} #{vkey} == '#{vval}'"
                else
                  "#{vkey} == '#{vval}'"
                end
              end
              filter_value << ")"
            else
              val.each do |vkey, vval|
                filter_value << " #{multi_filter(key)} #{vkey} == '#{vval}'".strip
              end
              next
            end
          end
        end
      end

      def multi_filter(key)
        filter_value.length.positive? ? MULTIPLE[key] : ""
      end

      def default_multi_filter
        filter_value.length.positive? ? " #{MULTIPLE[:and]}" : ""
      end
    end
  end
end

# {
#   popularity: { lt: 10 }
#   popularity: { gt: 10 }
#   title: { in: ["foo"]}
#   combo: [:title, :slug], match: "foo"
#   title: { not: ["foo"]}
#   not: {id: { in: :path }}
#   not: awardWinner
#   is: awardWinner
#   and:
#   or:
#   offset:
#   limit:
#   order:
#   defined:
#   select: [:_id, :_type]
# }
