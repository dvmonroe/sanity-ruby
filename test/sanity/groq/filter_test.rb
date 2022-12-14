# frozen_string_literal: true

require "test_helper"

describe Sanity::Groq::Filter do
  subject { Sanity::Groq::Filter }

  describe ".call" do
    it { assert_equal "_id == '123'", subject.call(_id: "123") }
    it { assert_equal "_id == '123' && _type == 'movie'", subject.call(_id: "123", _type: "movie") }
    it { assert_equal "active == true", subject.call(active: true) }

    context "logical operators" do
      it { assert_equal "_id == '123' && (_type == 'movie' || url == 'www.bar.com')", subject.call(_id: "123", and: {or: {_type: "movie", url: "www.bar.com"}}) }
      it { assert_equal "_type == 'movie' && (_type == 'cast' || _type == 'actor')", subject.call(_type: "movie", and: {or: [{_type: "cast"}, {_type: "actor"}]}) }
      it { assert_equal "_type == 'movie' || _type == 'cast' || _type == 'actor'", subject.call(_type: "movie", or: [{_type: "cast"}, {_type: "actor"}]) }
      it { assert_equal "_id == '123' || _type == 'movie' || url == 'www.bar.com'", subject.call(_id: "123", or: {_type: "movie", url: "www.bar.com"}) }
      it { assert_equal "_id == '123' || _type == 'movie'", subject.call(_id: "123", or: {_type: "movie"}) }
      it { assert_equal "_id == '123' && _type == 'movie'", subject.call(and: {_id: "123", _type: "movie"}) }
    end

    context "comparison operators" do
      it { assert_equal "_id != '123'", subject.call(_id: {not: "123"}) }
      it { assert_equal "_id != '123' && _type == 'movie'", subject.call(_id: {not: "123"}, _type: "movie") }
      it { assert_equal "popularity > 10", subject.call(popularity: {gt: 10}) }
      it { assert_equal "_type == 'movie' && popularity >= 10", subject.call(_type: "movie", popularity: {gt_eq: 10}) }
      it { assert_equal "popularity < 10", subject.call(popularity: {lt: 10}) }
      it { assert_equal "popularity <= 10", subject.call(popularity: {lt_eq: 10}) }
      it { assert_equal "popularity == 10", subject.call(popularity: {is: 10}) }
      it { assert_equal "popularity > 10 || _type == 'movie'", subject.call(popularity: {gt: 10}, or: {_type: "movie"}) }
      it { assert_equal "_type == 'movie' || popularity > 10", subject.call(_type: "movie", or: {popularity: {gt: 10}}) }
    end

    context "word matching" do
      it { assert_equal "title in [\"Aliens\", \"Interstellar\"]", subject.call(title: %i[Aliens Interstellar]) }
      it { assert_equal "text match 'wo*'", subject.call(text: {match: "wo*"}) }
    end

  end
end
