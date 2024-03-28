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

body = {name: "user@institution.edu", email: "user@institution.edu"}
user = client.users.search_by_email(body[:email])
if user.uuid
  puts "User already exists"
else
  user = client.users.create(**body)
  puts user.inspect
end
