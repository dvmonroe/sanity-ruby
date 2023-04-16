# frozen_string_literal: true

require "test_helper"

describe Sanity::Groq::Order do
  subject { Sanity::Groq::Order }
  it { assert_equal %i[order], subject::RESERVED }

  describe ".call" do
    context "when args include order" do
      context "when order is a symbol" do
        it "raises an ArgumentError" do
          assert_raises ArgumentError do
            subject.call(order: :foo)
          end
        end
      end

      context "when order is a hash" do
        it { assert_equal "| order(createdAt desc)", subject.call(order: {createdAt: :desc}) }
      end

      context "when order is a hash with multiple k/v pairs" do
        it "returns expected string" do
          assert_equal \
            "| order(createdAt desc) | order(updatedAt asc)",
            subject.call(order: {createdAt: :desc, updatedAt: :asc})
        end
      end
    end

    context "when args don't include order" do
      it { assert_nil subject.call(foo: 3) }
    end
  end
end
