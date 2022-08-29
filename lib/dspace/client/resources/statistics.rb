# frozen_string_literal: true

module DSpace
  class StatisticsResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/statistics-reports.md"
    ENDPOINT = "statistics/usagereports"

    def objects(**params)
      response = get_request("#{ENDPOINT}/search/object", params: params)
      DSpace::List.from_response(response, key: "usagereports", type: DSpace::UsageReport)
    end
  end
end
