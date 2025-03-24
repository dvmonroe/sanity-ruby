# frozen_string_literal: true

require "test_helper"

describe Sanity::Configuration do
  subject { Sanity::Configuration.new }

  after do
    Sanity.use_global_config = false
    Sanity.configure do |config|
      config.project_id = ""
      config.dataset = ""
      config.api_version = ""
      config.token = ""
      config.use_cdn = false
    end
  end

  it { assert_equal "", subject.project_id }
  it { assert_equal "", subject.dataset }
  it { assert_equal "", subject.api_version }
  it { assert_equal "", subject.token }
  it { refute subject.use_cdn }

  describe "#api_subdomain" do
    context "when use_cdn is false" do
      it { assert_equal "api", subject.api_subdomain }
    end

    context "when use_cdn is true" do
      before { subject.stubs(use_cdn: true) }
      it { assert_equal "apicdn", subject.api_subdomain }
    end
  end

  describe "thread safety" do
    context "when use_global_config is nil" do
      before do
        Sanity.use_global_config = false
        Sanity.configure do |config|
          config.project_id = "Project 20"
          config.dataset = "Dataset 20"
          config.api_version = "v20"
          config.token = "Token 20"
          config.use_cdn = nil
        end
      end

      it "maintains separate configurations across threads" do
        threads = []
        configurations = []

        4.times do |i|
          threads << Thread.new do
            Sanity.configure do |config|
              config.project_id = "Project#{i}"
              config.dataset = "Dataset#{i}"
              config.api_version = "v#{i}"
              config.token = "Token#{i}"
              config.use_cdn = i.even?
            end

            configurations << {
              index: i,
              **Sanity.config.to_h
            }
          end
        end

        threads.each(&:join)

        configurations.sort_by { |config| config[:index] }.each_with_index do |config, i|
          assert_equal "Project#{i}", config[:project_id]
          assert_equal "Dataset#{i}", config[:dataset]
          assert_equal "v#{i}", config[:api_version]
          assert_equal "Token#{i}", config[:token]
          assert_equal i.even?, config[:use_cdn]
        end
      end
    end

    context "when use_global_config is true" do
      before do
        Sanity.use_global_config = true
        Sanity.configure do |config|
          config.project_id = "Project 1"
          config.dataset = "Dataset 1"
          config.api_version = "v1"
          config.token = "Token 1"
          config.use_cdn = true
        end
      end

      it "maintains config across threads" do
        threads = []
        configurations = []

        4.times do |i|
          threads << Thread.new do
            configurations << {
              index: i,
              **Sanity.config.to_h
            }
          end
        end

        threads.each(&:join)

        configurations.each do |config|
          assert_equal "Project 1", config[:project_id]
          assert_equal "Dataset 1", config[:dataset]
          assert_equal "v1", config[:api_version]
          assert_equal "Token 1", config[:token]
          assert_equal true, config[:use_cdn]
        end
      end
    end
  end
end
