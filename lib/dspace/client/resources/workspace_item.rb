# frozen_string_literal: true

module DSpace
  class WorkspaceItemResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/workspaceitems.md"

    def default_endpoint
      "submission/workspaceitems"
    end

    def list(**params)
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "workspaceitems", type: DSpace::WorkspaceItem)
    end

    def retrieve(id:)
      DSpace::WorkspaceItem.new client, get_request(id).body
    end

    def delete(id:)
      delete_request(id)
    end
  end
end
