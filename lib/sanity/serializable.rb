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
        @default_serializer ||=
          if auto_serialize?
            class_serializer
          elsif defined?(@serializer)
            @serializer
          end
      end

      def auto_serialize?
        return @auto_serialize if defined?(@auto_serialize)

        superclass.respond_to?(:auto_serialize?) && superclass.auto_serialize?
      end

      private

      def auto_serialize
        @auto_serialize = true
      end

      def serializer(serializer)
        @serializer = serializer
      end

      def class_serializer
        @class_serializer ||= proc do |results|
          key = results.key?("result") ? "result" : "documents"
          results[key].map do |result|
            attributes = result.slice(*self.attributes.map(&:to_s))
            new(**attributes.transform_keys(&:to_sym))
          end
        end
      end
    end
  end
end
