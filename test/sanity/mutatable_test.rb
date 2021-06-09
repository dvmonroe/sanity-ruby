# frozen_string_literal: true

require "test_helper"

describe Sanity::Mutatable do
  describe "class methods" do
    context "no mutatable limitations defined" do
      let(:klass) { Class.new { include Sanity::Mutatable; mutatable } }
      subject { klass.new }

      it { assert_respond_to klass, :create }
      it { assert_respond_to klass, :create_or_replace }
      it { assert_respond_to klass, :create_if_missing }
      it { assert_respond_to subject, :create_or_replace }
      it { assert_respond_to subject, :patch }
      it { assert_respond_to subject, :destroy }
    end

    context "with mutatable limitations defined" do
      let(:klass) { Class.new { include Sanity::Mutatable; mutatable only: %i(create patch) } }
      subject { klass.new }

      it { assert_respond_to klass, :create }
      it { assert_respond_to subject, :patch }

      it { refute_respond_to klass, :create_or_replace }
      it { refute_respond_to klass, :create_if_missing }

      it { refute_respond_to subject, :create_or_replace }
      it { refute_respond_to subject, :destroy }
    end
  end
end
