# frozen_string_literal: true

require "test_helper"

class WorkspaceItemsResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("workspace_items_list") do
      client.login
      items = client.workspace_items.list
      assert_equal DSpace::List, items.class
      assert_equal DSpace::WorkspaceItem, items.data.first.class
      assert_equal 22, items.total_pages
    end
  end

  def test_create
    # VCR.use_cassette("workspace_items_create") do
    #   client.login
    # end
  end

  def test_retrieve
    # id     = 11
    # client = build_client
    # VCR.use_cassette("workspace_items_retrieve") do
    #   item = client.workspace_items.retrieve(id: id)
    #   assert_equal DSpace::WorkspaceItem, item.class
    #   assert_equal "X", item.name
    # end
  end

  def test_update
    # id = 11
    # body = {}
    # client = build_client
    # VCR.use_cassette("workspace_items_update") do
    #   client.login
    #   assert_equal "X", client.items.update(id: id, **body)
    # end
  end

  def test_delete
    # id = 11
    # client = build_client
    # VCR.use_cassette("workspace_items_delete") do
    #   client.login
    #   assert client.items.delete(id: id)
    # end
  end
end
