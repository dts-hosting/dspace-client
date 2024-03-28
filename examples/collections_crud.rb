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
  name: "DTS.COLLECTION.001",
  metadata: {
    "dc.title": [
      {
        value: "DTS.COLLECTION.001",
        language: nil,
        authority: nil,
        confidence: -1
      }
    ]
  }
}

community = client.communities.list.data.first
collection = client.collections.create(parent: community.uuid, **body)
puts "CREATE"
puts collection.inspect

# READ
collection = client.collections.retrieve(uuid: collection.uuid)
puts "READ"
puts collection.inspect

# UPDATE
body = {op: "replace", path: "/metadata/dc.title/0", value: {value: "DTS.COLLECTION.002"}}
collection = client.collections.update(uuid: collection.uuid, **body)
puts "UPDATE"
puts collection.inspect

# DELETE
puts "DELETE"
puts client.collections.delete(uuid: collection.uuid).inspect
