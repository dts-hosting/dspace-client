# frozen_string_literal: true

require "test_helper"

class ItemsResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("items_list") do
      client.login
      items = client.items.list
      assert_equal DSpace::List, items.class
      assert_equal DSpace::Item, items.data.first.class
      assert_equal 30, items.total_pages
    end
  end

  def test_create
    body = {
      name: "DTS.ITEM.001",
      metadata: {
        "dc.title": [
          {
            value: "DTS.ITEM.001",
            language: nil,
            authority: nil,
            confidence: -1
          }
        ]
      },
      inArchive: true,
      discoverable: true,
      withdrawn: false,
      type: "item"
    }
    client = build_client
    VCR.use_cassette("items_create") do
      client.login
      collection = client.collections.list.data.first
      item = client.items.create(parent: collection.uuid, **body)
      assert_equal DSpace::Item, item.class
      assert item.inArchive
    end
  end

  def test_retrieve
    uuid = "5eb19b24-9a37-4386-858e-131eb3db5c66"
    client = build_client
    VCR.use_cassette("items_retrieve") do
      item = client.items.retrieve(uuid: uuid)
      assert_equal DSpace::Item, item.class
      assert_equal "DTS.ITEM.001", item.name
    end
  end

  def test_update
    uuid = "5eb19b24-9a37-4386-858e-131eb3db5c66"
    body = {op: "add", path: "/metadata/dc.contributor.author/0", value: "TEST"}
    client = build_client
    VCR.use_cassette("items_update") do
      client.login
      assert_equal "TEST", client.items.update(uuid: uuid, **body).metadata["dc.contributor.author"][0].value
    end
  end

  def test_delete
    uuid = "5eb19b24-9a37-4386-858e-131eb3db5c66"
    client = build_client
    VCR.use_cassette("items_delete") do
      client.login
      assert client.items.delete(uuid: uuid)
    end
  end
end
