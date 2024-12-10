# frozen_string_literal: true

module DSpace
  class BasicReportTask
    attr_reader :client, :output_file

    HEADERS = %w[community collection item visits downloads created updated url date file_types].freeze
    THREAD_COUNT = 8

    def initialize(client:, output_file:)
      @client = client
      @output_file = output_file
    end

    def process(opts: {page_size: 20, throttle: 0})
      FileUtils.rm_f output_file
      size = opts[:page_size]
      data = Queue.new

      client.items.all(embed: "owningCollection/parentCommunity,bundles/bitstreams", size: size).each_slice(size) do |items|
        Parallel.map(items, in_threads: THREAD_COUNT) do |item|
          data << collect_stats(item, Time.now.utc.iso8601)
          sleep opts[:throttle]
        rescue => e
          puts "Error processing item\n#{item.inspect}:\n#{e.message}"
        end
        write_data(data.pop) until data.empty?
      end
    end

    private

    def collect_stats(item, date)
      stats = client.statistics.objects(uri: item._links.self.href)
      collection = item["_embedded"].owningCollection
      community = collection["_embedded"].parentCommunity
      {
        community: community.name,
        collection: collection.name,
        item: item.name,
        visits: get_views(stats.data, "TotalVisits"),
        downloads: get_views(stats.data, "TotalDownloads"),
        created: item.metadata["dc.date.accessioned"]&.first&.value,
        updated: item.lastModified,
        url: get_stats_url(item),
        date: date,
        file_types: get_file_types(item).join(";")
      }
    end

    def get_file_types(item)
      item["_embedded"].bundles["_embedded"].bundles.map { |bundle|
        bundle["_embedded"].bitstreams
      }.map { |bitstreams|
        bitstreams["_embedded"]
      }.each.map { |bitstream|
        bitstream.bitstreams.each.map { |file|
          ::File.extname(file.name)
        }
      }.flatten.uniq
    rescue => e
      puts "Error getting file types:\n#{e.message}"
      ""
    end

    def get_stats_url(data)
      data._links.self.href.gsub("/server/api/core/", "/statistics/")
    end

    def get_views(data, type)
      data.find { |r| r["report-type"] == type }.points.inject(0) do |sum, p|
        sum + p.values.views
      end
    end

    def write_data(data)
      CSV.open(output_file, "a") do |csv|
        csv << HEADERS if csv.stat.zero?
        csv << data.values_at(*HEADERS.map(&:to_sym))
      end
    end
  end
end
