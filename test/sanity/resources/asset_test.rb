# frozen_string_literal: true

require "test_helper"

describe Sanity::Asset do
  let(:klass) { Sanity::Asset }

  it { assert_respond_to klass, :create }
end
