# frozen_string_literal: true

require "test_helper"

class SearchResourceTest < Minitest::Test
  def test_objects_all
    client = build_client
    VCR.use_cassette("search_objects_all") do
      client.login
      search = client.search.objects(query: "")
      assert_equal DSpace::List, search.class
      assert_equal DSpace::Item, search.data.first.class
      assert_equal 775, search.total_elements
      assert_equal 39, search.total_pages
    end
  end

  def test_objects_by_type
    client = build_client
    VCR.use_cassette("search_objects_by_type") do
      client.login
      search = client.search.objects(query: "Closed Collection", dsoType: "collection")
      assert_equal DSpace::List, search.class
      assert_equal DSpace::Collection, search.data.first.class
      assert_equal 1, search.total_elements
      assert_equal 1, search.total_pages
    end
  end

  def test_objects_by_scope
    client = build_client
    VCR.use_cassette("search_objects_by_scope") do
      client.login
      search = client.search.objects(query: "Closed Collection", dsoType: "collection")
      search = client.search.objects(scope: search.data.first.uuid, dsoType: "item")
      assert_equal DSpace::List, search.class
      assert_equal DSpace::Item, search.data.first.class
      assert_equal 3, search.total_elements
      assert_equal 1, search.total_pages
    end
  end
end
