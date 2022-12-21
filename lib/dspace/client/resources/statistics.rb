# frozen_string_literal: true

module DSpace
  class StatisticsResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/statistics-reports.md"

    def default_endpoint
      "statistics/usagereports"
    end

    def objects(**params)
      response = get_request("search/object", params: params)
      DSpace::List.from_response(client, response, key: "usagereports", type: DSpace::UsageReport)
    end
  end
end
