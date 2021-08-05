# Sanity

![](https://github.com/morning-brew/sanity-ruby/actions/workflows/ci.yml/badge.svg)
<a href="https://codeclimate.com/github/morning-brew/sanity-ruby/maintainability"><img src="https://api.codeclimate.com/v1/badges/1984ee6eb0bce46a2469/maintainability" /></a>

The Sanity Ruby library provides convenient access to the Sanity API from applications written in Ruby. It includes a pre-defined set of classes for API resources.

The library also provides other features, like:

- Easy configuration for fast setup and use.
- A pre-defined class to help make any PORO a "sanity resource"
- Extensibility in overriding the wrapper of your API response results
- A small DSL around GROQ queries

## Contents

- [Sanity](#sanity)
  - [Contents](#contents)
  - [Getting Started](#getting-started)
  - [Mutating](#mutating)
  - [Querying](#querying)
  - [Development](#development)
  - [Contributing](#contributing)
  - [License](#license)

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'sanity-ruby'
```

Setup your configuration. If using in Rails, consider setting this in an initializer:

```ruby
Sanity.configure do |s|
  s.token = "yoursupersecrettoken"
  s.api_version = "v2021-03-25"
  s.project_id = "1234"
  s.dataset = "development"
  s.use_cdn = false
end
```

To create a new document:

```ruby
Sanity::Document.create(params: {_type: "user", first_name: "Carl", last_name: "Sagan"})
```

You can also return the created document ID.

```ruby
res = Sanity::Document.create(params: {_type: "user", first_name: "Carl", last_name: "Sagan"}, options: {return_ids: true})

# JSON.parse(res.body)["results"]
# > [{"id"=>"1fc471c6434fdc654ba447", "operation"=>"create"}]
```

To create a new asset:

```ruby
# TODO
```

To make any PORO a sanity resource:

```ruby
class User < Sanity::Resource
  attribute :_id, default: ""
  attribute :_type: default: ""
  mutatable only: %i(create delete)
  queryable
end
```

To create a new document in Sanity:

```ruby
User.create(params: { first_name: "Carl", last_name: "Sagan" })
```

or if you need to validate the object in your application first:

```ruby
user = User.new(first_name: "Carl", last_name: "Sagan")
# your business logic here...
user.create
```

To make any PORO act like a sanity resource:

```ruby
class User
  include Sanity::Mutatable
  include Sanity::Queryable
  queryable
  mutatable
end
```

## Mutating

To [create a document](https://www.sanity.io/docs/http-mutations#c732f27330a4):

```ruby
Sanity::Document.create(params: {_type: "user", first_name: "Carl", last_name: "Sagan"})
```

To [create or replace a document](https://www.sanity.io/docs/http-mutations#95bb692d7fb0):

```ruby
Sanity::Document.create_or_replace(params: { _id: "1234-321", _type: "user", first_name: "Carl", last_name: "Sagan"})
```

To [create a document if it does not exist](https://www.sanity.io/docs/http-mutations#bd91661cae0c):

```ruby
Sanity::Document.create_if_not_exists(params: { _id: "1234-321", _type: "user", first_name: "Carl", last_name: "Sagan"})
```

To [delete a document](https://www.sanity.io/docs/http-mutations#40a9a879af9b):

```ruby
Sanity::Document.delete(params: { _id: "1234-321"})
```

To [patch a document](https://www.sanity.io/docs/http-mutations#2f480b2baca5):

```ruby
Sanity::Document.patch(params: { _id: "1234-321", set: { first_name: "Carl" }})
```

## Querying

To [find document(s) by id](https://www.sanity.io/docs/http-doc):

```ruby
Sanity::Document.find(_id: "1234-321")
```

To find documents based on certain fields:

[Where](https://www.sanity.io/docs/query-cheat-sheet#3949cadc7524)

_majority supported_

```ruby
where: {
  _id: "123", # _id == '123'
  _id: {not: "123"} # _id != '123'
  title: {match: "wo*"} # title match 'wo*'
  popularity: {gt: 10}, # popularity > 10
  popularity: {gt_eq: 10}, # popularity >= 10
  popularity: {lt: 10}, # popularity < 10
  popularity: {lt_eq: 10}, # popularity <= 10
  _type: "movie", or: {_type: "cast"} # _type == 'movie' || _type == 'cast'
  _type: "movie", and: {or: [{_type: "cast"}, {_type: "person"}]} # _type == 'movie' && (_type == 'cast' || _type == 'person')
  _type: "movie", or: [{_type: "cast"}, {_type: "person"}] # _type == 'movie' || _type == 'cast' || _type == 'person'
}
```

```ruby
Sanity::Document.where(_type: "user", and: {or: {_id:  "123", first_name: "Carl" }})
# Resulting GROQ:
# *[_type == 'user' && (_id == '123' || first_name == 'Carl')]
```

[Order](https://www.sanity.io/docs/query-cheat-sheet#b5aec96cf56c)

_partially supported_

```ruby
order: { createdAt: :desc, updatedAt: :asc }
# order(createdAt desc) | order(updatedAt asc)
```

[Limit](https://www.sanity.io/docs/query-cheat-sheet#170b92d4caa2)

```ruby
limit: 5, offset: 10
```

```ruby
Sanity::Document.where(_type: "user", limit: 5, offset: 2)
```

[Select](https://www.sanity.io/docs/query-cheat-sheet#55d30f6804cc)

_partially supported_

```ruby
select: [:_id, :slug, :title, :name]
```

```ruby
Sanity::Document.where(_type: "user", select: %i[first_name last_name])
```

Should you need more advanced querying that isn't handled in this gem's DSL you can pass a raw groq query

[Query Cheat Sheet](https://www.sanity.io/docs/query-cheat-sheet)

```ruby
groq_query = <<-GROQ
  *[ _type =='movie' && name == $name] {
    title,
    poster {
      asset-> {
        path,
        url
      }
    }
  }
GROQ

Sanity::Document.where(groq: groq_query, variables: {name: "Monsters, Inc."})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/morning-brew/sanity-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
