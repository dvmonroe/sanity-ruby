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
  end
end
