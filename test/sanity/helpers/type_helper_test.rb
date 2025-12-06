# frozen_string_literal: true

require "test_helper"

describe Sanity::TypeHelper do
  describe ".default_type" do
    context "Sanity::Document" do
      subject { Sanity::Document }
      it { assert_nil(Sanity::TypeHelper.default_type(subject)) }
    end

    context "non Sanity::Document" do
      before { Object.const_set(:Foobar, Class.new) }
      after { Object.send(:remove_const, :Foobar) }

      subject { Foobar }
      it { assert_equal "foobar", Sanity::TypeHelper.default_type(subject) }
    end

    context "Sanity::Document" do
      context "without a custom document_type" do
        before { Object.const_set(:Quux, Class.new(Sanity::Document)) }
        after { Object.send(:remove_const, :Quux) }

        subject { Quux }

        it { assert_equal "quux", Sanity::TypeHelper.default_type(subject) }
      end

      context "with custom document_type" do
        before do
          Object.const_set(:BarBaz, Class.new(Sanity::Document) do
            self.document_type = "custom_type"
          end)
        end
        after { Object.send(:remove_const, :BarBaz) }

        subject { BarBaz }

        it { assert_equal "custom_type", Sanity::TypeHelper.default_type(subject) }
      end
    end
  end
end
