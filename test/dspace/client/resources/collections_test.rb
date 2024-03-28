# frozen_string_literal: true

require "test_helper"

class CollectionsResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("collections_list") do
      collection = client.collections.list
      assert_equal DSpace::List, collection.class
      assert_equal DSpace::Collection, collection.data.first.class
      assert_equal 6, collection.total_pages
    end
  end

  def test_create
    body = {
      name: "DTS.COLLECTION.001",
      metadata: {
        "dc.title": [
          {
            value: "DTS.COLLECTION.001",
            language: nil,
            authority: nil,
            confidence: -1
          }
        ]
      }
    }
    client = build_client
    VCR.use_cassette("collections_create") do
      client.login
      collection = client.collections.create(parent: "05891e91-ea50-4d41-bb60-ee8803057ae4", **body)
      assert_equal DSpace::Collection, collection.class
      assert_equal "DTS.COLLECTION.001", collection.name
    end
  end

  def test_retrieve
    uuid = "d1456d11-760e-4760-b1b7-06988506e4b0"
    client = build_client
    VCR.use_cassette("collections_retrieve") do
      collection = client.collections.retrieve(uuid: uuid)
      assert_equal DSpace::Collection, collection.class
      assert_equal "DTS.COLLECTION.001", collection.name
    end
  end

  def test_update
    uuid = "d1456d11-760e-4760-b1b7-06988506e4b0"
    body = {op: "replace", path: "/metadata/dc.title/0",
            value: {value: "DTS.COLLECTION.002"}}
    client = build_client
    VCR.use_cassette("collections_update") do
      client.login
      assert_equal "DTS.COLLECTION.002",
        client.collections.update(uuid: uuid, **body).metadata["dc.title"].first.value
    end
  end

  def test_delete
    uuid = "d1456d11-760e-4760-b1b7-06988506e4b0"
    client = build_client
    VCR.use_cassette("collections_delete") do
      client.login
      assert client.collections.delete(uuid: uuid)
    end
  end
end
