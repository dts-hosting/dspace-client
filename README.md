# DSpace REST API Client

A Ruby DSpace REST API client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dspace-client'
bundle install
```

## Usage

```ruby
config = DSpace::Configuration.new({rest_url: '', username: '', password: ''})
# Or find config from env or file ~/.dspaceclientrc
config = DSpace::Configuration.find # raises error if not found

client = DSpace::Client.new(config)
client.login
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dspace-client.
