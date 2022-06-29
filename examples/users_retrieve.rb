# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"

config = DSpace::Configuration.new(settings: {
                                     rest_url: "https://demo.dspacedirect.net/server/api",
                                     username: "demo@dspacedirect.org",
                                     password: "direct!"
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
