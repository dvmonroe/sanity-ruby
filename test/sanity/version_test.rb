# frozen_string_literal: true

require "test_helper"

describe Sanity::VERSION do
  subject { Sanity::VERSION }

  it { refute_nil subject }
end
