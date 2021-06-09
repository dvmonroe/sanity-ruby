# frozen_string_literal: true

require "test_helper"

describe Sanity::Document do
  let(:klass) { Sanity::Document }
  subject { klass.new }

  it { assert_respond_to klass, :create }
  it { assert_respond_to klass, :create_or_replace }
  it { assert_respond_to klass, :create_if_missing }
  it { assert_respond_to subject, :create_or_replace }
  it { assert_respond_to subject, :patch }
  it { assert_respond_to subject, :destroy }

  it { assert_respond_to subject, :_id }
  it { assert_respond_to subject, :_type }

  it { assert_respond_to klass, :find }
  it { assert_respond_to klass, :where }
end
