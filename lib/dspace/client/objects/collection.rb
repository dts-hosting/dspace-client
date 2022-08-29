# frozen_string_literal: true

module DSpace
  class Collection < Object
    def items
      DSpace::ItemResource.new(client: client, endpoint: "core/collections/#{uuid}/mappedItems")
    end
  end
end
