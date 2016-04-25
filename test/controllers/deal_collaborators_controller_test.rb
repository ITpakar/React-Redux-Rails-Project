require 'test_helper'

class DealCollaboratorsControllerTest < ActionController::TestCase
  setup do
    @deal_collaborator = deal_collaborators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deal_collaborators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deal_collaborator" do
    assert_difference('DealCollaborator.count') do
      post :create, deal_collaborator: { added_by: @deal_collaborator.added_by, deal_id: @deal_collaborator.deal_id, user_id: @deal_collaborator.user_id }
    end

    assert_redirected_to deal_collaborator_path(assigns(:deal_collaborator))
  end

  test "should show deal_collaborator" do
    get :show, id: @deal_collaborator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deal_collaborator
    assert_response :success
  end

  test "should update deal_collaborator" do
    patch :update, id: @deal_collaborator, deal_collaborator: { added_by: @deal_collaborator.added_by, deal_id: @deal_collaborator.deal_id, user_id: @deal_collaborator.user_id }
    assert_redirected_to deal_collaborator_path(assigns(:deal_collaborator))
  end

  test "should destroy deal_collaborator" do
    assert_difference('DealCollaborator.count', -1) do
      delete :destroy, id: @deal_collaborator
    end

    assert_redirected_to deal_collaborators_path
  end
end
