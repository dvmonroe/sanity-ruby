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
            string_var: "hello",
            array_var: [1, 2, 3],
            array_of_strings: ["foo", "bar"],
            hash_var: {"foo" => "bar"},
            number_var: 42,
            boolean_var: true
          }
        end

        it "properly serializes variables in the query string" do
          uri = subject.send(:uri)
          decoded_query = URI.decode_www_form_component(uri.query)

          assert_includes decoded_query, "$string_var=\"hello\""
          assert_includes decoded_query, "$array_var=[1,2,3]"
          assert_includes decoded_query, "$array_of_strings=[\"foo\",\"bar\"]"
          assert_includes decoded_query, "$hash_var={\"foo\":\"bar\"}"
          assert_includes decoded_query, "$number_var=42"
          assert_includes decoded_query, "$boolean_var=true"
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
