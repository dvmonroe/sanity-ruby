# Sanity

The Sanity Ruby library provides convenient access to the Sanity API from applications written in Ruby. It includes a pre-defined set of classes for API resources that initialize themselves dynamically from API responses when applicable.

The library also provides other features. For example:

    Easy configuration for fast setup and use.
    A pre-defined class to help make any PORO a "sanity resource"
    Extensibility in overriding the wrapper of your API response results

## Contents

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

To create a new document:

```ruby
Sanity::Document.create(params: {_type: "user", first_name: "Carl", last_name: "Sagan"})
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

TODO

## Querying

TODO

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sanity.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
