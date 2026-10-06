# frozen_string_literal: true

require "test_helper"

class CollectionObjectTest < Minitest::Test
  UUID = "d1456d11-760e-4760-b1b7-06988506e4b0"

  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
    @client = build_stubbed_client(@stubs)
    @collection = DSpace::Collection.new(@client, {uuid: UUID, name: "DTS.COLLECTION.001"})
  end

  def test_get_workflowgroup
    @stubs.get(stub_url("core/collections/#{UUID}/workflowGroups/reviewer")) do
      json_response({uuid: "group-uuid", name: "COLLECTION_#{UUID}_WORKFLOW_ROLE_reviewer", type: "group"})
    end

    group = @collection.get_workflowgroup("reviewer")
    assert_equal DSpace::Group, group.class
    assert_equal "group-uuid", group.uuid
    assert_equal "COLLECTION_#{UUID}_WORKFLOW_ROLE_reviewer", group.name
    @stubs.verify_stubbed_calls
  end

  def test_get_workflowgroup_when_role_has_no_group
    # DSpace returns 204 No Content when the workflow role has no group
    @stubs.get(stub_url("core/collections/#{UUID}/workflowGroups/editor")) { [204, {}, ""] }

    assert_nil @collection.get_workflowgroup("editor")
    @stubs.verify_stubbed_calls
  end

  def test_get_workflowgroup_when_no_content_response_is_typed_as_json
    # the JSON middleware parses an empty body to nil
    @stubs.get(stub_url("core/collections/#{UUID}/workflowGroups/editor")) do
      [204, {"Content-Type" => "application/json"}, ""]
    end

    assert_nil @collection.get_workflowgroup("editor")
    @stubs.verify_stubbed_calls
  end

  def test_delete_workflowgroup
    @stubs.delete(stub_url("core/collections/#{UUID}/workflowGroups/finaleditor")) { [204, {}, ""] }

    assert_equal 204, @collection.delete_workflowgroup("finaleditor").status
    @stubs.verify_stubbed_calls
  end

  def test_workflow_roles
    assert_equal ["reviewer", "editor", "finaleditor"], DSpace::Collection::WORKFLOW_ROLES
  end
end
