# frozen_string_literal: true

module Sanity
  class Configuration
    # @return [String] Sanity's project id
    attr_accessor :project_id

    # @return [String] Sanity's dataset
    attr_accessor :dataset

    # @return [String] Sanity's api version
    attr_accessor :api_version

    # @return [String] Sanity's api token
    attr_accessor :token

    # @return [Boolean] whether to use Sanity's cdn api
    attr_accessor :use_cdn

    def initialize
      @project_id = ""
      @dataset = ""
      @api_version = ""
      @token = ""
      @use_cdn = false
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class << self
    alias_method :config, :configuration
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
