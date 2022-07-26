# frozen_string_literal: true

module DSpace
  class WorkspaceItemResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/workspaceitems.md"
    ENDPOINT = "submission/workspaceitems"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::List.from_response(response, key: "workspaceitems", type: DSpace::WorkspaceItem)
    end

    def retrieve(id:)
      DSpace::WorkspaceItem.new get_request("#{ENDPOINT}/#{id}").body
    end

    def delete(id:)
      delete_request("#{ENDPOINT}/#{id}")
    end
  end
end
