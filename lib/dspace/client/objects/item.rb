# frozen_string_literal: true

module DSpace
  class Item < Object
    def bundles
      DSpace::BundleResource.new(client: client, endpoint: "core/items/#{uuid}/bundles")
    end

    def collection
      DSpace::Collection.new(
        client,
        DSpace::Request.new(client: client).get_request("core/items/#{uuid}/owningCollection").body
      )
    end
  end
end
