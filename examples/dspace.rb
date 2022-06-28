#!/usr/bin/ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"

config = DSpace::Configuration.new(settings: { rest_url: "https://demo.dspacedirect.net/server/api", username: "",
                                               password: "" })
client = DSpace::Client.new(config: config)
# puts client.connection.get("core/communities", {}).body
puts client.connection.get("core/items", {}).body
