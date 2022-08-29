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

def traverse(community, client)
  community.client = client
  yield community if block_given?
  return unless community.subcommunities.list.total_elements.positive?

  community.subcommunities.all.each do |subcommunity|
    traverse(subcommunity, client)
  end
end

# traverse the hierarchy: community -> [subcommunity] -> collections -> items
client.communities.all.each do |community|
  traverse(community, client) do |c|
    puts c.name
    c.collections.all.each do |collection|
      collection.client = client
      puts collection.name
      collection.items.all.each do |item|
        puts item.inspect
      end
    end
  end
  break # To do this for realz would take a long time
end
