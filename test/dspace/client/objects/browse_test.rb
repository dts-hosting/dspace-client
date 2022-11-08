# frozen_string_literal: true

require "test_helper"

class BrowseObjectTest < Minitest::Test
  def test_items
    client = build_client
    VCR.use_cassette("browse_items") do
      browse = client.browses.retrieve(id: "dateissued")
      items = browse.items.list
      assert_equal DSpace::List, items.class
      assert_equal DSpace::Item, items.data.first.class
      assert_equal 29, items.total_pages
    end
  end
end
