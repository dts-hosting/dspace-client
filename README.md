# DSpace REST API Client

A Ruby DSpace REST API client.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "dspace-client"
bundle install
```

## Usage

```ruby
config = DSpace::Configuration.new(settings: {rest_url: "", username: "", password: ""})
# Or find config from env or file ~/.dspaceclientrc
config = DSpace::Configuration.find # raises error if not found

client = DSpace::Client.new(config: config)
client.status # not authenticated
client.login
client.status # authenticated (assuming credentials are correct)
```

See also the `examples` folder. To run the examples you'll need to define some ENV variables:

- DSPACE_CLIENT_REST_URL : https://example.dspace.org/server/api
- DSPACE_CLIENT_USERNAME : admin
- DSPACE_CLIENT_PASSWORD : admin

## Development

- `bin/setup` # install dependencies
- `bin/console` # irb session

```ruby
# example console interactions
@client.login
@client.status
@client.collections.list.data
```

Run tests & lint:

```ruby
bundle exec rake
bundle exec rubocop
```

However the tests / fixtures are run & generated against a live service
and therefore the `DSPACE_*` env variables are required (and required to be
correct [meaning the same as was used to generate the fixture]).

In the future the goal is to target a sandbox server that doesn't
require hidden credentials so new tests / fixtures can be added without
obfuscating the login details.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dspace-client.
