# frozen_string_literal: true

require "test_helper"

describe Sanity::Resource do
  let(:klass) {
    Class.new(Sanity::Resource) {
      attribute :id
      attribute :name
    }
  }
  subject { klass.new }

  it { assert_respond_to klass, :default_serializer }
  it { assert_respond_to subject, :attributes }

  describe "auto serialization" do
    subject {
      Class.new(Sanity::Resource) do
        attribute :id
        attribute :name
        auto_serialize
      end
    }

    let(:result_data) { {"result" => [{"id" => 1, "name" => "Test Result"}]} }
    let(:documents_data) { {"documents" => [{"id" => 2, "name" => "Test Document"}]} }

    it "correctly serializes data with 'result' key" do
      serialized_objects = subject.default_serializer.call(result_data)
      assert_equal 1, serialized_objects.first.id
      assert_equal "Test Result", serialized_objects.first.name
    end

    it "correctly serializes data with 'documents' key" do
      serialized_objects = subject.default_serializer.call(documents_data)
      assert_equal 2, serialized_objects.first.id
      assert_equal "Test Document", serialized_objects.first.name
    end
  end
end
