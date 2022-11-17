# frozen_string_literal: true

module Sanity
  # Serializable is responsible for configuring auto serialization or a default
  # serializer. It also defines the default class serializer used when auto
  # serialization is enabled.
  #
  # The auto_serialize macro is used to enable auto serialization.
  #
  # @example enables auto serialization
  #   auto_serialize
  #
  # The serializer marco is used to define the default serializer.
  #
  # @example default to using a custom defined UserSerializer
  #   serializer UserSerializer
  #
  module Serializable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def default_serializer
        @default_serializer ||= nil
      end

      private

      def auto_serialize
        @default_serializer = class_serializer
      end

      def serializer(serializer)
        @default_serializer = serializer
      end

      def class_serializer
        @class_serializer ||= Proc.new do |results|
          results['result'].map do |result|
            attributes = result.slice(*self.attributes.map(&:to_s))
            self.new(**attributes.transform_keys(&:to_sym))
          end
        end
      end

    end

    attr_reader :default_serializer

  end
end
