# frozen_string_literal: true

require "test_helper"
class CustomSerializer; end

class BaseClass < Sanity::Resource
  auto_serialize
end

class InheritedClass < BaseClass; end

describe Sanity::Serializable do
  describe "class methods" do
    context "without auto_serialize defined" do
      subject {
        Class.new do
          include Sanity::Serializable
        end
      }

      it { assert_nil subject.default_serializer }
    end

    context "with auto_serialize defined" do
      subject {
        Class.new do
          include Sanity::Serializable
          auto_serialize
        end
      }

      it { refute_nil subject.default_serializer }
      it { assert subject.auto_serialize? }
      it { assert_equal subject.send(:class_serializer), subject.default_serializer }
    end

    context "with auto_serialize defined on parent of inheritted class" do
      subject { InheritedClass }

      it { refute_nil subject.default_serializer }
      it { assert subject.auto_serialize? }
      it { assert_equal subject.send(:class_serializer), subject.default_serializer }
    end

    context "with custom serializer defined" do
      subject {
        Class.new do
          include Sanity::Serializable
          serializer CustomSerializer
        end
      }

      it { assert_equal CustomSerializer, subject.default_serializer }
    end
  end
end
