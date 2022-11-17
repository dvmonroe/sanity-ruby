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
      DEFAULT_KLASS_MUTATIONS = %i[create create_or_replace create_if_not_exists patch delete].freeze
      DEFAULT_INSTANCE_MUTATIONS = %i[create create_or_replace create_if_not_exists delete].freeze
      ALL_MUTATIONS = DEFAULT_KLASS_MUTATIONS | DEFAULT_INSTANCE_MUTATIONS

      private

      def mutatable(**options)
        options.fetch(:only, ALL_MUTATIONS).each do |mutation|
          if DEFAULT_KLASS_MUTATIONS.include? mutation.to_sym
            define_singleton_method(mutation) do |**args|
              default_args = { resource_klass: self }
              if !self.is_a?(Sanity::Document)
                default_type = self.to_s
                default_type[0] = default_type[0].downcase
                default_args.merge!(_type: default_type)
              end
              Module.const_get("Sanity::Http::#{mutation.to_s.classify}").call(
                **args.merge(default_args)
              )
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
