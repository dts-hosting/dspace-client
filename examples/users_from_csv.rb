# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dotenv/load"
require "dspace/client"
require "csv"

config = DSpace::Configuration.new(settings: {
  rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
  username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
  password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
})
puts ENV.fetch("DSPACE_CLIENT_REST_URL")
puts ENV.fetch("DSPACE_CLIENT_PASSWORD")
client = DSpace::Client.new(config: config)
client.login

# Path to your CSV file
csv_file_path = "examples/users.csv"

# Open the CSV file and iterate through each row
CSV.foreach(csv_file_path, headers: true) do |row|
  # Access data in each row using headers
  email = row["email"]
  firstname = row["firstname"]
  lastname = row["lastname"]
  groups = row["groups"]

  # Print each row to the console
  puts "#{firstname} #{lastname} - #{email}; #{groups}"

  # create user
  # https://github.com/DSpace/RestContract/blob/main/epersons.md#create-new-eperson-requires-admin-permissions
  body = {
    name: email.to_s,
    metadata: {
      "eperson.firstname": [
        {
          value: firstname.to_s,
          language: nil,
          authority: "",
          confidence: -1
        }
      ],
      "eperson.lastname": [
        {
          value: lastname.to_s,
          language: nil,
          authority: "",
          confidence: -1
        }
      ]
    },
    canLogIn: true,
    email: email.to_s,
    requireCertificate: false,
    selfRegistered: true,
    type: "eperson"
  }
  user = client.users.search_by_email(body[:email])
  if user.uuid
    puts "User already exists"
  else
    user = client.users.create(**body)
    puts user.inspect
  end

  # TODO: add user to group(s)
  # https://github.com/DSpace/RestContract/blob/main/epersongroups.md
  grouparr = groups.split(",")
  grouparr.each { |group|
    selectgroup = client.groups.search_by_metadata(group).data.first
    puts selectgroup._links.epersons.href
  }

  # TODO: send registration
  # https://github.com/DSpace/RestContract/blob/main/epersonregistrations.md
end
