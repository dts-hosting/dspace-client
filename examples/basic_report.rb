# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"
require "time"

config = DSpace::Configuration.new(settings: {
                                     rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
                                     username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
                                     password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
                                   })
client = DSpace::Client.new(config: config)
client.login

require "csv"
REPORT_FILE = "report.csv"
REPORT_HEADERS = %w[community collection item visits downloads created updated url date].freeze
FileUtils.rm_f REPORT_FILE

def collect_stats(client, community, collection, item, date)
  stats = client.statistics.objects(uri: item._links.self.href)
  data  = {
    community: community.name,
    collection: collection.name,
    item: item.name,
    visits: get_views("TotalVisits", stats.data),
    downloads: get_views("TotalDownloads", stats.data),
    created: item.metadata["dc.date.accessioned"]&.first&.value,
    updated: item.lastModified,
    url: get_stats_url(item),
    date: date
  }

  CSV.open(REPORT_FILE, "a") do |csv|
    csv << REPORT_HEADERS if csv.stat.zero?
    csv << data.values_at(*REPORT_HEADERS.map(&:to_sym))
  end
end

def get_stats_url(record)
  record._links.self.href.gsub("/server/api/core/", "/statistics/")
end

def get_views(type, data)
  data.find { |r| r["report-type"] == type }.points.inject(0) do |sum, p|
    sum + p.values.views
  end
end

def traverse(community, client)
  community.client = client
  yield community if block_given?
  return unless community.subcommunities.list.total_elements.positive?

  community.subcommunities.all.each do |subcommunity|
    traverse(subcommunity, client)
  end
end

client.communities.all.each do |c|
  traverse(c, client) do |community|
    community.collections.all.each do |collection|
      puts "Gathering stats for collection: [#{community.name}] #{collection.name}"
      client.search.all(scope: collection.uuid, dsoType: "item").each do |item|
        collect_stats(client, community, collection, item, Time.now.utc.iso8601)
      end
    end
  end
end
