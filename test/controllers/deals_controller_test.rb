require 'test_helper'

class DealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deal = deals(:one)
  end

  test "should get index" do
    get deals_url
    assert_response :success
  end

  test "should get new" do
    get new_deal_url
    assert_response :success
  end

  test "should create deal" do
    assert_difference('Deal.count') do
      post deals_url, params: { deal: { activated: @deal.activated, admin_user_id: @deal.admin_user_id, client_name: @deal.client_name, completion_percent: @deal.completion_percent, deal_size: @deal.deal_size, organization_id: @deal.organization_id, projected_close_date: @deal.projected_close_date, status: @deal.status, title: @deal.title, transaction_type: @deal.transaction_type } }
    end

    assert_redirected_to deal_path(Deal.last)
  end

  test "should show deal" do
    get deal_url(@deal)
    assert_response :success
  end

  test "should get edit" do
    get edit_deal_url(@deal)
    assert_response :success
  end

  test "should update deal" do
    patch deal_url(@deal), params: { deal: { activated: @deal.activated, admin_user_id: @deal.admin_user_id, client_name: @deal.client_name, completion_percent: @deal.completion_percent, deal_size: @deal.deal_size, organization_id: @deal.organization_id, projected_close_date: @deal.projected_close_date, status: @deal.status, title: @deal.title, transaction_type: @deal.transaction_type } }
    assert_redirected_to deal_path(@deal)
  end

  test "should destroy deal" do
    assert_difference('Deal.count', -1) do
      delete deal_url(@deal)
    end

    assert_redirected_to deals_path
  end
end
