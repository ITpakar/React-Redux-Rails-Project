require 'test_helper'

class DealCollaboratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal_collaborator = deal_collaborators(:one)
  end

  test "should get index" do
    get deal_collaborators_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_collaborator_url
    assert_response :success
  end

  test "should create deal_collaborator" do
    assert_difference('DealCollaborator.count') do
      post deal_collaborators_url, params: { deal_collaborator: { added_by: @deal_collaborator.added_by, deal_id: @deal_collaborator.deal_id, user_id: @deal_collaborator.user_id } }
    end

    assert_redirected_to deal_collaborator_path(DealCollaborator.last)
  end

  test "should show deal_collaborator" do
    get deal_collaborator_url(@deal_collaborator)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_collaborator_url(@deal_collaborator)
    assert_response :success
  end

  test "should update deal_collaborator" do
    patch deal_collaborator_url(@deal_collaborator), params: { deal_collaborator: { added_by: @deal_collaborator.added_by, deal_id: @deal_collaborator.deal_id, user_id: @deal_collaborator.user_id } }
    assert_redirected_to deal_collaborator_path(@deal_collaborator)
  end

  test "should destroy deal_collaborator" do
    assert_difference('DealCollaborator.count', -1) do
      delete deal_collaborator_url(@deal_collaborator)
    end

    assert_redirected_to deal_collaborators_path
  end
end
