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

# CREATE
body = {
  name: "DTS.ITEM.001",
  metadata: {
    "dc.title": [
      {
        value: "DTS.ITEM.001",
        language: nil,
        authority: nil,
        confidence: -1
      }
    ]
  },
  inArchive: true,
  discoverable: true,
  withdrawn: false,
  type: "item"
}

collection = client.collections.list.data.first
item = client.items.create(parent: collection.uuid, **body)
puts "CREATE"
puts item.inspect

item.client = client
item.bundles.create({ name: "ORIGINAL", metadata: {} })
puts item.bundles.list.inspect
