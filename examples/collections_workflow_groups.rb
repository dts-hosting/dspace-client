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

client.collections.all.each do |collection|
  puts collection.name
  DSpace::Collection::WORKFLOW_ROLES.each do |role|
    group = collection.get_workflowgroup(role)
    if group
      puts "#{role} group: #{group.name}"
      # NOTE: uncomment ONLY to remove all workflows from the site
      # puts "deleting #{role}"
      # puts collection.delete_workflowgroup(role).inspect
    else
      puts "#{role} does not exist"
    end
  end
end
