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

search_total = client.search.objects(query: "*").total_elements
community_total = client.communities.list.total_elements
collection_total = client.collections.list.total_elements
items_total = client.items.list.total_elements
records_total = community_total + collection_total + items_total

puts search_total
puts records_total
