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

# Unrestricted
search = client.search.objects(query: "")
puts search.data
puts search.total_elements
puts search.total_pages

# Specific collection record
search = client.search.objects(query: "Publications", dsoType: "collection")
puts search.data
puts search.total_elements
puts search.total_pages

# Items scoped to collection record
client.search.all(scope: search.data.first.uuid, dsoType: "item").each do |i|
  puts i.inspect
end
