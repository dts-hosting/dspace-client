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
REPORT_FILE = "report.csv"
REPORT_HEADERS = %w[collection item visits downloads date].freeze
FileUtils.rm_f REPORT_FILE

def get_views(type, data)
  data.find { |r| r["report-type"] == type }.points.inject(0) do |sum, p|
    sum + p.values.views
  end
end

def collect_stats(client, collection, item)
  stats = client.statistics.objects(uri: item._links.self.href)
  visits = get_views("TotalVisits", stats.data)
  downloads = get_views("TotalDownloads", stats.data)

  CSV.open(REPORT_FILE, "a") do |csv|
    csv << REPORT_HEADERS if csv.stat.zero?
    csv << [collection.name, item.name, visits, downloads, Time.now.utc.to_s]
  end
end

client.collections.all.each do |collection|
  puts "Gathering stats for collection: #{collection.name}"
  client.search.all(scope: collection.uuid, dsoType: "item").each do |item|
    collect_stats(client, collection, item)
  end
end
