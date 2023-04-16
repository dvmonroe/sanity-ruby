# frozen_string_literal: true

require "test_helper"

describe Sanity::Resource do
  let(:klass) { Sanity::Resource }
  subject { klass.new }

  it { assert_respond_to klass, :default_serializer }

  it { assert_respond_to subject, :attributes }
end
