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

    context "api endpoint URLs" do
      subject {
        Class.new do
          include Sanity::Queryable
          queryable
        end
      }

      it "returns correct find API endpoint" do
        assert_equal "data/doc", subject.find_api_endpoint
      end

      it "returns correct where API endpoint" do
        assert_equal "data/query", subject.where_api_endpoint
      end
    end

    context "with an empty `:only` array" do
      subject {
        Class.new do
          include Sanity::Queryable
          queryable only: []
        end
      }

      it { refute_respond_to subject, :find }
      it { refute_respond_to subject, :where }
    end
  end
end
