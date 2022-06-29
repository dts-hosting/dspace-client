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

body = { name: "user@institution.edu", email: "user@institution.edu" }
user = client.users.search(email: body[:email])
if user.uuid
  puts "User already exists"
else
  response = client.users.create(**body)
  puts response.inspect
end
