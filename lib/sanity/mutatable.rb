# frozen_string_literal: true

module Sanity
  # Mutatable is responsible for setting the appropriate class methods
  # that invoke Sanity::Http's mutatable classes
  #
  # The mutatable marco can limit what queries are accessible to the
  # mutatable object
  #
  # @example provides default class methods
  #   mutatable
  #
  # @example only add the `.create` method
  #   mutatable only: %i(create)
  #
  # @example only add the `.create_or_replace`& `#create_or_replace` methods
  #   mutatable only: %i(create_or_replace)
  #
  using Sanity::Refinements::Strings

  module Mutatable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      COMMON_MUTATIONS = %i[create create_or_replace create_if_not_exists delete].freeze
      DEFAULT_KLASS_MUTATIONS = (COMMON_MUTATIONS + [:patch]).freeze
      DEFAULT_INSTANCE_MUTATIONS = COMMON_MUTATIONS
      ALL_MUTATIONS = DEFAULT_KLASS_MUTATIONS | DEFAULT_INSTANCE_MUTATIONS

      private

      def mutatable(**options)
        options.fetch(:only, ALL_MUTATIONS).each do |mutation|
          if DEFAULT_KLASS_MUTATIONS.include? mutation.to_sym
            define_singleton_method(mutation) do |**args|
              Module.const_get("Sanity::Http::#{mutation.to_s.classify}").call(**args.merge(resource_klass: self))
            end
          end

          if DEFAULT_INSTANCE_MUTATIONS.include? mutation.to_sym
            define_method(mutation) do |**args|
              Module.const_get("Sanity::Http::#{mutation.to_s.classify}").call(
                **args.merge(params: attributes, resource_klass: self.class)
              )
            end
          end
        end

        define_singleton_method(:mutatable_api_endpoint) { options.fetch(:api_endpoint, "") }
      end
    end
  end
end
