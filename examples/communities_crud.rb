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
  name: "DTS.COMMUNITY.001",
  metadata: {
    "dc.title": [
      {
        value: "DTS.COMMUNITY.001",
        language: nil,
        authority: nil,
        confidence: -1
      }
    ]
  }
}
community = client.communities.search_by_metadata(body[:name]).data.first
if community&.uuid
  puts "Community already exists"
else
  community = client.communities.create(**body)
  puts "CREATE"
  puts community.inspect
end

# READ
community = client.communities.retrieve(uuid: community.uuid)
puts "READ"
puts community.inspect

# UPDATE
body = { op: "replace", path: "/metadata/dc.title/0", value: { value: "DTS.COMMUNITY.002" } }
community = client.communities.update(uuid: community.uuid, **body)
puts "UPDATE"
puts community.inspect

# DELETE
puts "DELETE"
puts client.communities.delete(uuid: community.uuid).inspect
