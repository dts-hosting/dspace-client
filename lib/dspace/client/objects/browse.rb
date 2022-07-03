# frozen_string_literal: true

module DSpace
  class Browse < Object
    def items
      DSpace::ItemResource.new(client: client, endpoint: "discover/browses/#{id}/items")
    end
  end
end
