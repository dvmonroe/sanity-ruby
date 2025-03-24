source "https://rubygems.org"

# Specify your gem's dependencies in sanity.gemspec
gemspec

gem "rake", ">= 12.0"
gem "minitest", "~> 5.0"
gem "minitest-reporters", ">= 1.4"
gem "mocha", ">= 1.12"
gem "pry"

gem "guard"
gem "guard-minitest"
gem "yard"

gem "standard"

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new("3.0")
  gem "ffi", "~> 1.16.3"
else
  gem "ffi"
end
