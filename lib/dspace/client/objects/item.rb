# frozen_string_literal: true

module DSpace
  class Item < Object
    def bundles
      DSpace::BundleResource.new(client: client, endpoint: "core/items/#{uuid}/bundles")
    end
  end
end
