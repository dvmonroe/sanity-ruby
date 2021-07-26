# frozen_string_literal: true

require "test_helper"

describe Sanity::Groqify do
  subject { Sanity::Groqify }

  it "defines RESERVED" do
    assert_equal \
      %i[and or not is gt gt_eq lt lt_eq match limit offset order select].sort,
      subject::RESERVED.sort
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
        [
          Sanity::Groq::Order,
          Sanity::Groq::Slice,
          Sanity::Groq::Select,
          Sanity::Groq::Filter
        ].each { |klass| klass.expects(:call).with(foo: :bar).returns(true) }

        subject.call(**args)
      end
    end
  end
end
