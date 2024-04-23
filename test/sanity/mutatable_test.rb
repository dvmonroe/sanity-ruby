# frozen_string_literal: true

require "test_helper"

describe Sanity::Mutatable do
  describe "class methods" do
    context "no mutatable limitations defined" do
      let(:klass) {
        Class.new do
          include Sanity::Mutatable
          mutatable
        end
      }
      subject { klass.new }

      it { assert_respond_to klass, :create }
      it { assert_respond_to klass, :create_or_replace }
      it { assert_respond_to klass, :create_if_not_exists }
      it { assert_respond_to klass, :delete }
      it { assert_respond_to klass, :patch }
      it { assert_respond_to klass, :publish }
      it { assert_respond_to klass, :unpublish }

      it { assert_respond_to subject, :create }
      it { assert_respond_to subject, :create_or_replace }
      it { assert_respond_to subject, :create_if_not_exists }
      it { assert_respond_to subject, :delete }
      it { assert_respond_to subject, :publish }
      it { assert_respond_to subject, :unpublish }
    end

    context "with mutatable limitations defined" do
      let(:klass) {
        Class.new do
          include Sanity::Mutatable
          mutatable only: %i[create patch]
        end
      }
      subject { klass.new }

      it { assert_respond_to klass, :create }
      it { assert_respond_to subject, :create }

      it { assert_respond_to klass, :patch }

      it { refute_respond_to klass, :create_or_replace }
      it { refute_respond_to klass, :create_if_not_exists }
      it { refute_respond_to klass, :delete }
      it { refute_respond_to klass, :publish }
      it { refute_respond_to klass, :unpublish }

      it { refute_respond_to subject, :create_if_not_exists }
      it { refute_respond_to subject, :create_or_replace }
      it { refute_respond_to subject, :delete }
      it { refute_respond_to subject, :publish }
      it { refute_respond_to subject, :unpublish }
    end
  end
end
