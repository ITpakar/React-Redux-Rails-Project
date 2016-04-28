require 'test_helper'

class StarredDealsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @starred_deal = starred_deals(:one)
  end

  test "should get index" do
    get starred_deals_url
    assert_response :success
  end

  test "should get new" do
    get new_starred_deal_url
    assert_response :success
  end

  test "should create starred_deal" do
    assert_difference('StarredDeal.count') do
      post starred_deals_url, params: { starred_deal: { deal_id: @starred_deal.deal_id, user_id: @starred_deal.user_id } }
    end

    assert_redirected_to starred_deal_path(StarredDeal.last)
  end

  test "should show starred_deal" do
    get starred_deal_url(@starred_deal)
    assert_response :success
  end

  test "should get edit" do
    get edit_starred_deal_url(@starred_deal)
    assert_response :success
  end

  test "should update starred_deal" do
    patch starred_deal_url(@starred_deal), params: { starred_deal: { deal_id: @starred_deal.deal_id, user_id: @starred_deal.user_id } }
    assert_redirected_to starred_deal_path(@starred_deal)
  end

  test "should destroy starred_deal" do
    assert_difference('StarredDeal.count', -1) do
      delete starred_deal_url(@starred_deal)
    end

    assert_redirected_to starred_deals_path
  end
end
