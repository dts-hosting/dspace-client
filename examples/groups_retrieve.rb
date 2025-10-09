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

groups = client.groups.list.data
# group = client.groups.retrieve(uuid: groups.first.uuid)

groups.each do |group|
  # puts group.inspect

  # Show some interactions
  puts "uuid: #{group.uuid}"
  puts "name: #{group.name}"
  puts "dc.title: #{begin
    group.metadata["dc.title"].first.value
  rescue
    "no title"
  end}"
  puts "dc.description: #{begin
    group.metadata["dc.description"].first.value
  rescue
    "no description"
  end}"
  puts "users:"
  group.epersons.list.data.each do |user|
    puts "#{user.metadata["eperson.firstname"].first.value} #{user.metadata["eperson.lastname"].first.value}, #{user.email} (#{user.uuid})"
  end
  # todo: not working yet
  # puts "subgroups:"
  # puts group.subgroups.list.inspect
  # for subgroup in group.subgroups.list.all.each
  #   puts subgroup
  #   puts "subgroup uuid: #{subgroup.uuid}"
  # end
end
