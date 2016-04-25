require 'test_helper'

class DealsControllerTest < ActionController::TestCase
  setup do
    @deal = deals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:deals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create deal" do
    assert_difference('Deal.count') do
      post :create, deal: { activated: @deal.activated, admin_user_id: @deal.admin_user_id, client_name: @deal.client_name, completion_percent: @deal.completion_percent, deal_size: @deal.deal_size, organization_id: @deal.organization_id, projected_closing_date: @deal.projected_closing_date, status: @deal.status, title: @deal.title, transaction_type: @deal.transaction_type }
    end

    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should show deal" do
    get :show, id: @deal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @deal
    assert_response :success
  end

  test "should update deal" do
    patch :update, id: @deal, deal: { activated: @deal.activated, admin_user_id: @deal.admin_user_id, client_name: @deal.client_name, completion_percent: @deal.completion_percent, deal_size: @deal.deal_size, organization_id: @deal.organization_id, projected_closing_date: @deal.projected_closing_date, status: @deal.status, title: @deal.title, transaction_type: @deal.transaction_type }
    assert_redirected_to deal_path(assigns(:deal))
  end

  test "should destroy deal" do
    assert_difference('Deal.count', -1) do
      delete :destroy, id: @deal
    end

    assert_redirected_to deals_path
  end
end
