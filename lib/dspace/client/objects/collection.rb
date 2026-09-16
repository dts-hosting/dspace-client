# frozen_string_literal: true

module DSpace
  class Collection < Object
    WORKFLOW_ROLES = ["reviewer", "editor", "finaleditor"].freeze

    def items
      DSpace::ItemResource.new(client: client, endpoint: "core/collections/#{uuid}/mappedItems")
    end

    def get_workflowgroup(workflow_role)
      response = DSpace::Request.new(client: client).get_request("server/api/core/collections/#{uuid}/workflowGroups/#{workflow_role}")
      unless response.body.empty?
        DSpace::Group.new(
          client,
          response.body
        )
      end
    end

    def delete_workflowgroup(workflow_role)
      DSpace::Request.new(client: client, endpoint: "core/collections/#{uuid}/workflowGroups").delete_request(workflow_role)
    end
  end
end
