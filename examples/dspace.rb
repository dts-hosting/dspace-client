# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"

config = DSpace::Configuration.new(settings: {
                                     rest_url: "https://demo.dspacedirect.net/server/api",
                                     username: "demo@dspacedirect.org",
                                     password: "direct!"
                                   })
client = DSpace::Client.new(config: config)
puts client.login
response = client.get("core/items")
puts response.status
puts response.body
