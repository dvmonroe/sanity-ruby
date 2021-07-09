# frozen_string_literal: true

require "test_helper"

describe Sanity::Groq::Select do
  subject { Sanity::Groq::Select }
  it { assert_equal %i[select], subject::RESERVED }

  describe ".call" do
    context "when args include select" do
      context "when select is a symbol" do
        it { assert_equal "{ foo }", subject.call(select: :foo) }
      end

      context "when select is a string" do
        it { assert_equal "{ foo }", subject.call(select: "foo") }
      end

      context "when select is an array of symbols" do
        it { assert_equal "{ foo, bar }", subject.call(select: %i[foo bar]) }
      end
    end

    context "when args don't include select" do
      it { assert_nil subject.call(foo: 3) }
    end
  end
end
