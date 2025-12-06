# frozen_string_literal: true

module Sanity
  module TypeHelper
    def self.default_type(klass)
      return nil if klass == Sanity::Document

      type = (klass.try(:document_type) || klass).to_s

      type[0].downcase + type[1..]
    end
  end
end
