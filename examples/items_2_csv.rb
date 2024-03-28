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

require "csv"

def append_row(file, data)
  CSV.open(file, "a", encoding: "utf-8") do |row|
    row << data
  end
end

outfile = "handles.csv"
FileUtils.rm_f outfile
append_row(outfile, %w[id name handle]) # headers

client.items.all.each do |i|
  append_row(outfile, [i.id, i.name, i.handle])
end
