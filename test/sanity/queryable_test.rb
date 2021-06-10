# frozen_string_literal: true

require "test_helper"

describe Sanity::Queryable do
  describe "class methods" do
    context "no queryable limitations defined" do
      subject {
        Class.new do
          include Sanity::Queryable
          queryable
        end
      }

      it { assert_respond_to subject, :find }
      it { assert_respond_to subject, :where }
    end

    context "with queryable limitations defined" do
      subject {
        Class.new do
          include Sanity::Queryable
          queryable only: %i[where]
        end
      }

      it { refute_respond_to subject, :find }
      it { assert_respond_to subject, :where }
    end
  end
end
