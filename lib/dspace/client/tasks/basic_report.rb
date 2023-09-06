# frozen_string_literal: true

module DSpace
  class BasicReportTask
    attr_reader :client, :output_file

    HEADERS = %w[community collection item visits downloads created updated url date].freeze

    def initialize(client:, output_file:)
      @client = client
      @output_file = output_file
    end

    def process(opts: { page_size: 20, throttle: 0 })
      FileUtils.rm_f output_file
      size = opts[:page_size]
      client.communities.all(size: size).each do |c|
        traverse(c) do |community|
          community.collections.all(size: size).each do |collection|
            puts "Gathering stats for collection: [#{community.name}] #{collection.name}"
            client.search.all(scope: collection.uuid, dsoType: "item", size: size).each do |item|
              collect_stats(community, collection, item, Time.now.utc.iso8601)
            end
            sleep opts[:throttle]
          end
          break
        end
      end
    end

    private

    def collect_stats(community, collection, item, date)
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

      CSV.open(output_file, "a") do |csv|
        csv << HEADERS if csv.stat.zero?
        csv << data.values_at(*HEADERS.map(&:to_sym))
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

    def traverse(community)
      yield community if block_given?
      return unless community.subcommunities.list.total_elements.positive?

      community.subcommunities.all.each do |subcommunity|
        traverse(subcommunity, client)
      end
    end
  end
end
