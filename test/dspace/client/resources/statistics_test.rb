# frozen_string_literal: true

require "test_helper"

class SearchResourceTest < Minitest::Test
  def test_objects_community
    client = build_client
    VCR.use_cassette("statistics_objects_community") do
      client.login
      stats = client.statistics.objects(
        uri: "https://demo.dspacedirect.org/communities/f076d168-ecc4-439f-a6c7-271b612c624d"
      )
      assert_equal DSpace::List, stats.class
      assert_equal DSpace::UsageReport, stats.data.first.class
    end
  end

  def test_objects_collection
    client = build_client
    VCR.use_cassette("statistics_objects_collection") do
      client.login
      stats = client.statistics.objects(
        uri: "https://demo.dspacedirect.org/collections/2a55fdff-2c0f-43e5-8970-97924d31e880"
      )
      assert_equal DSpace::List, stats.class
      assert_equal DSpace::UsageReport, stats.data.first.class
    end
  end

  def test_objects_item
    client = build_client
    VCR.use_cassette("statistics_objects_item") do
      client.login
      stats = client.statistics.objects(
        uri: "https://demo.dspacedirect.org/items/5a852610-086c-4d4a-a5ac-b5b953565e57"
      )
      assert_equal DSpace::List, stats.class
      assert_equal DSpace::UsageReport, stats.data.first.class
    end
  end
end
