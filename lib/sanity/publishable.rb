# frozen_string_literal: true

module Sanity
  # Publishable is responsible for setting the appropriate class methods
  # that invoke Sanity::Http's publishable actions
  #
  # The publishable macro can limit what actions are accessible to the
  # publishable object
  #
  # @example provides default class methods
  #   publishable
  #
  # @example only add the `.publish` method
  #   publishable only: %i(publish)
  #
  # @example only add the `.unpublish`& `#unpublish` methods
  #   publishable only: %i(unpublish)
  #
  using Sanity::Refinements::Strings

  module Publishable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      PUBLISHABLE_ACTIONS = %i[publish unpublish].freeze

      private

      def publishable(**options)
        options.fetch(:only, PUBLISHABLE_ACTIONS).each do |action|
          if PUBLISHABLE_ACTIONS.include? action.to_sym
            define_singleton_method(action) do |args|
              Module.const_get("Sanity::Http::#{action.to_s.classify}").call(args)
            end
          end

          if PUBLISHABLE_ACTIONS.include? action.to_sym
            define_method(action) do
              Module.const_get("Sanity::Http::#{action.to_s.classify}").call(attributes["_id"])
            end
          end
        end
      end
    end
  end
end
