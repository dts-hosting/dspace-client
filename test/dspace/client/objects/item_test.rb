# frozen_string_literal: true

require "test_helper"

class ItemObjectTest < Minitest::Test
  def test_collection
    stubs = Faraday::Adapter::Test::Stubs.new
    client = build_stubbed_client(stubs)
    stubs.get(stub_url("core/items/item-uuid/owningCollection")) do
      json_response({uuid: "collection-uuid", name: "DTS.COLLECTION.001", type: "collection"})
    end

    collection = DSpace::Item.new(client, {uuid: "item-uuid"}).collection
    assert_equal DSpace::Collection, collection.class
    assert_equal "collection-uuid", collection.uuid
    stubs.verify_stubbed_calls
  end
end
