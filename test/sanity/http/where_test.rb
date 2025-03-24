# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Where do
  let(:klass) { Sanity::Http::Where }
  let(:resource_class) do
    Class.new do
      def self.where_api_endpoint
        "test"
      end
    end
  end

  describe "query parameter serialization" do
    describe "with GET requests" do
      subject { klass.new(resource_klass: resource_class, variables: variables) }

      describe "with different variable types" do
        let(:variables) do
          {
            "string_var" => "hello",
            "array_var" => [1, 2, 3],
            "hash_var" => {"foo" => "bar"},
            "number_var" => 42,
            "boolean_var" => true
          }
        end

        it "properly serializes variables in the query string" do
          uri = subject.send(:uri)
          query_params = URI.decode_www_form(uri.query).to_h

          assert_equal "\"hello\"", query_params["$string_var"]
          assert_equal "[1,2,3]", query_params["$array_var"]
          assert_equal "{\"foo\":\"bar\"}", query_params["$hash_var"]
          assert_equal "42", query_params["$number_var"]
          assert_equal "true", query_params["$boolean_var"]
        end
      end
    end

    describe "with POST requests" do
      subject { klass.new(resource_klass: resource_class, variables: variables, use_post: true) }

      let(:variables) do
        {
          "string_var" => "hello",
          "array_var" => [1, 2, 3]
        }
      end

      it "includes variables in the request body" do
        body = JSON.parse(subject.send(:request_body))
        assert_equal variables, body["params"]
      end
    end
  end
end
