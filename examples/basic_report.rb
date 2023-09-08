# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "benchmark"
require "dspace/client"
require "time"

config = DSpace::Configuration.new(settings: {
                                     rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
                                     username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
                                     password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
                                   })
client = DSpace::Client.new(config: config)
client.login

begin
  puts(Benchmark.measure do
    client.basic_report("report.csv").process(opts: { page_size: 100, throttle: 0 })
  end)
rescue StandardError => e
  puts "There was an error while processing the report: #{e.message}"
end
