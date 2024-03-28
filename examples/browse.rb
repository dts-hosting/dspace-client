# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"

config = DSpace::Configuration.new(settings: {
  rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
  username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
  password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
})
client = DSpace::Client.new(config: config)
client.login

# browse = client.browses.list.data.first # via all browses
browse = client.browses.retrieve(id: "dateissued")
puts browse.items.list.data

# get an item bundle
item = browse.items.list.data.first
puts item.bundles.list.data
