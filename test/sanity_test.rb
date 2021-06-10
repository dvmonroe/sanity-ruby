# frozen_string_literal: true

require "test_helper"

describe Sanity do
  subject { Sanity }

  it { assert_respond_to subject, :config }
  it { assert_respond_to subject, :configuration }
end
