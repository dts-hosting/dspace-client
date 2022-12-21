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

client.items.all.each do |item|
  item.bundles.all.each do |bundle|
    bundle.bitstreams.all.each do |bitstream|
      puts bitstream.uuid
      puts bitstream.name
      puts bitstream.checkSum.value
    end
  end
  break
end
