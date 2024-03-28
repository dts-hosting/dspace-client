# frozen_string_literal: true

require "test_helper"

class CommunitiesResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("communities_list") do
      communities = client.communities.list
      assert_equal DSpace::List, communities.class
      assert_equal DSpace::Community, communities.data.first.class
      assert_equal 4, communities.total_pages
    end
  end

  def test_create
    body = {
      name: "DTS.COMMUNITY.001",
      metadata: {
        "dc.title": [
          {
            value: "DTS.COMMUNITY.001",
            language: nil,
            authority: nil,
            confidence: -1
          }
        ]
      }
    }
    client = build_client
    VCR.use_cassette("communities_create") do
      client.login
      community = client.communities.create(**body)
      assert_equal DSpace::Community, community.class
      assert_equal "DTS.COMMUNITY.001", community.name
    end
  end

  def test_retrieve
    uuid = "41a47b5c-f63c-4f5a-8d9e-0aeb4803f9fd"
    client = build_client
    VCR.use_cassette("communities_retrieve") do
      community = client.communities.retrieve(uuid: uuid)
      assert_equal DSpace::Community, community.class
      assert_equal "DTS.COMMUNITY.001", community.name
    end
  end

  def test_update
    uuid = "41a47b5c-f63c-4f5a-8d9e-0aeb4803f9fd"
    body = {op: "replace", path: "/metadata/dc.title/0", value: {value: "DTS.COMMUNITY.002"}}
    client = build_client

    VCR.use_cassette("communities_update") do
      client.login
      assert_equal "DTS.COMMUNITY.002",
        client.communities.update(uuid: uuid, **body).metadata["dc.title"].first.value
    end
  end

  def test_delete
    uuid = "41a47b5c-f63c-4f5a-8d9e-0aeb4803f9fd"
    client = build_client
    VCR.use_cassette("communities_delete") do
      client.login
      assert client.communities.delete(uuid: uuid)
    end
  end
end
