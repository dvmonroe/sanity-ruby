# frozen_string_literal: true

require "test_helper"

describe Sanity::Document do
  let(:klass) { Sanity::Document }
  subject { klass.new }

  it { assert_respond_to klass, :create }
  it { assert_respond_to klass, :create_or_replace }
  it { assert_respond_to klass, :create_if_not_exists }
  it { assert_respond_to klass, :patch }
  it { assert_respond_to klass, :delete }

  it { assert_respond_to subject, :create }
  it { assert_respond_to subject, :create_or_replace }
  it { assert_respond_to subject, :create_if_not_exists }
  it { assert_respond_to subject, :delete }

  it { assert_respond_to subject, :_id }
  it { assert_respond_to subject, :_type }

  it { assert_respond_to klass, :find }
  it { assert_respond_to klass, :where }

  describe ".document_type" do
    it "allows setting a custom type name" do
      klass.document_type = "custom_type"
      assert_equal "custom_type", klass.document_type
    end

    it "returns nil when document_type is not set" do
      new_klass = Class.new(Sanity::Document)
      assert_nil new_klass.document_type
    end

    it "allows setting document_type to nil" do
      klass.document_type = "custom_type"
      assert_equal "custom_type", klass.document_type
      klass.document_type = nil
      assert_nil klass.document_type
    end
  end
end
