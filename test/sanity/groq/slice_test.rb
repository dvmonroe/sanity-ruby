# frozen_string_literal: true

require "test_helper"

describe Sanity::Groq::Slice do
  subject { Sanity::Groq::Slice }

  it { assert_equal %i[limit offset], subject::RESERVED }
  it { assert_equal 0, subject::ZERO_INDEX }

  describe ".call" do
    context "when args include limit" do
      it { assert_equal "[0...10]", subject.call(limit: 10) }
    end

    context "when args include limit and offset" do
      it { assert_equal "[3...13]", subject.call(limit: 10, offset: 3) }
    end

    context "when args only include offset" do
      it { assert_equal "", subject.call(offset: 3) }
    end
  end
end
