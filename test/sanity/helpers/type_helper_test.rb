# frozen_string_literal: true

require "test_helper"

describe Sanity::TypeHelper do
  describe ".default_type" do
    it "returns nil for classes including Sanity::Document" do
      document_class = Class.new do
        def self.is_a?(klass)
          klass == Sanity::Document
        end

        def self.to_s
          "DocumentClass"
        end
      end

      assert_nil(Sanity::TypeHelper.default_type(document_class))
    end

    it "returns downcased class name for regular classes" do
      regular_class = Class.new do
        def self.to_s
          "RegularClass"
        end
      end

      assert_equal "regularClass", Sanity::TypeHelper.default_type(regular_class)
    end
  end
end
