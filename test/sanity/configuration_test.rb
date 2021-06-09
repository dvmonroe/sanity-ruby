# frozen_string_literal: true

require "test_helper"

describe Sanity::Configuration do
  subject { Sanity::Configuration.new }

  it { assert_equal "", subject.project_id }
  it { assert_equal "", subject.dataset }
  it { assert_equal "", subject.api_version }
  it { assert_equal "", subject.token }
  it { refute subject.use_cdn }
end
