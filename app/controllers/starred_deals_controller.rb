class StarredDealsController < ApplicationController
  respond_to :json

  before_action :authentication_deal_collaborator!, only: [:create, :destroy]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal
  before_action :set_starred_deal, only: [:destroy]
  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    org_id  = params[:org_id]
    conditions  = []
    conditions << ["organization_id = ?", "#{org_id}"] if org_id
    deal_ids = current_user.deals.where(conditions[0]).pluck(:id)

    @starred_deals = current_user.starred_deals
                                 .where("id in (?)", deal_ids)
                                 .order("#{sortby} #{sortdir}")
                                 .page(@page).per(@per_page) rescue []
    success_response(
      {
        starred_deals: @starred_deals.map(&:to_hash)
      }
    )
  end

  def create
    @starred_deal = @deal.starred_deals.new(starred_deal_params)
    if @deal.save
      success_response(["Starred Deal created successfully."])
    else
      error_response(@starred_deal.errors)
    end
  end

  def destroy
    if @starred_deal.destroy
      success_response(["Starred Deal destroyed successfully"])
    else
      error_response(@starred_deal.errors)
    end
    return
  end

  private
  def set_deal
    @deal = Deal.find_by_id(params[:deal_id])
    error_response(["Deal Not Found."]) if @deal.blank?
  end

  def set_starred_deal
    @starred_deal = @deal.starred_deals.find_by_id(params[:id])
    error_response("Starred Deal Not Found") if @starred_deal.blank?
  end

  def starred_deal_params
    params.require(:starred_deal).permit(:user_id, :deal_id)
  end

  protected
  def ensure_params_exist
    if params[:starred_deal].blank?
      error_response(["Starred Deal related parameters not found."])
    end
  end
end
