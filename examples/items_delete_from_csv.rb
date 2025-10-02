# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dotenv/load"
require "dspace/client"

config = DSpace::Configuration.new(settings: {
  rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
  username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
  password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
})
client = DSpace::Client.new(config: config)
client.login

require "csv"

# Path to your CSV file
csv_file_path = "examples/items_to_delete.csv"

# Open the CSV file and iterate through each row
CSV.foreach(csv_file_path, headers: true) do |row|
  # Access data in each row using headers
  id = row["id"]
  title = row["dc.title"]

  # Print each row to the console
  puts "UUID: #{id}, Title: #{title}"

  begin
    item = client.items.delete(uuid: id)
    puts item.inspect
  rescue
    print "An error occurred: ", $!, "\n"
  end
end
