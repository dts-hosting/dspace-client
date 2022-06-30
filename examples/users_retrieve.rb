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

users = client.users.list.data
user  = client.users.retrieve(uuid: users.first.uuid)

puts user.inspect

# Show some interactions
puts user.uuid
puts user.canLogIn
puts user.metadata["eperson.firstname"].first.value
puts user.metadata["eperson.lastname"].first.value
