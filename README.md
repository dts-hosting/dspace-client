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
config = DSpace::Configuration.new(settings: {rest_url: '', username: '', password: ''})
# Or find config from env or file ~/.dspaceclientrc
config = DSpace::Configuration.find # raises error if not found

client = DSpace::Client.new(config: config)
client.login
```

## Development

- `bin/setup` # install dependencies
- `bin/console` # irb session

Run tests & lint:

```ruby
bundle exec rake
bundle exec rubocop
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dspace-client.
