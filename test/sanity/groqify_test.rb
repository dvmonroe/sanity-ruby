# frozen_string_literal: true

require "test_helper"

describe Sanity::Groqify do
  subject { Sanity::Groqify }

  it "defines RESERVED" do
    assert_equal \
      %i[and or not is gt gt_eq lt lt_eq match limit offset order select],
      subject::RESERVED
  end

  describe ".call" do
    context "no args" do
      it "returns expected string" do
        assert_equal "*[]", subject.call
      end
    end

    context "with args" do
      let(:args) { {foo: :bar} }

      it "invokes groq objects" do
        Sanity::Groq::Order.expects(:call).with(foo: :bar)
        Sanity::Groq::Slice.expects(:call).with(foo: :bar)
        Sanity::Groq::Select.expects(:call).with(foo: :bar)
        Sanity::Groq::Filter.expects(:call).with(foo: :bar)

        subject.call(**args)
      end
    end
  end
end
