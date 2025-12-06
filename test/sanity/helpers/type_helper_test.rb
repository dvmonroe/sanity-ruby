# frozen_string_literal: true

require "test_helper"

class Foobar; end

describe Sanity::TypeHelper do
  describe ".default_type" do
    context "Sanity::Document" do
      subject { Sanity::Document }
      it { assert_nil(Sanity::TypeHelper.default_type(subject)) }
    end

    context "non Sanity::Document" do
      subject { Foobar }
      it { assert_equal "foobar", Sanity::TypeHelper.default_type(subject) }
    end

    context "Sanity::Document" do
      context "without a custom document_type" do
        subject do
          Quux = Class.new(Sanity::Document)
          Quux
        end

        it { assert_equal "quux", Sanity::TypeHelper.default_type(subject) }
      end

      context "with custom document_type" do
        subject do
          BarBaz = Class.new(Sanity::Document) do
            self.document_type = "custom_type"
          end
          BarBaz
        end

        it { assert_equal "custom_type", Sanity::TypeHelper.default_type(subject) }
      end
    end
  end
end
