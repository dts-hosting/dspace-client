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

def print_stats(client, uri)
  puts uri
  stats = client.statistics.objects(uri: uri)
  stats.data.each do |report|
    puts "#{report.type} #{report["report-type"]}"
    report.points.each do |point|
      puts "[#{point.id}]: #{point.type} #{point.label} #{point.values.to_h}"
    end
    puts
  end

  puts "---\n\n"
end

print_stats(client, ARGV[0])
