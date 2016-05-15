class DealsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :authenticate_organization_member!, only: [:create]
  before_action :authentication_org_deal_admin!, only: [:update, :destroy]
  before_action :authentication_deal_collaborator!, only: [:show]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal, only: [:update, :destroy, :show]
  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    org_id  = params[:org_id]
    conditions  = []
    conditions << ["organization_id = ?", "#{org_id}"] if org_id
    if current_user.is_super?
      @deals = Deal.where(conditions[0])
                   .order("#{sortby} #{sortdir}")
                   .page(@page)
                   .per(@per_page) rescue []
    elsif current_user.is_organzation_admin?(current_user.organization.id)
      @deals = current_user.organization
                           .deals
                           .where(conditions[0])
                           .order("#{sortby} #{sortdir}")
                           .page(@page)
                           .per(@per_page) rescue []
    else
      @deals = current_user.deals
                           .where(conditions[0])
                           .order("#{sortby} #{sortdir}")
                           .page(@page)
                           .per(@per_page) rescue []
    end
    success_response(
      {
        deals: @deals.map(&:to_hash)
      }
    )
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      @deal.update(admin_user_id: current_user.id)
      success_response(["Deal created successfully."])
    else
      error_response(@deal.errors)
    end
  end

  def update
    if @deal.update(deal_params)
      success_response(["Deal updated successfully"])
    else
      error_response(@deal.errors)
    end
  end

  def show
    success_response(
      {
        deal: @deal.to_hash
      }
    )
  end

  def destroy
    if @deal.destroy
      success_response(["Deal destroyed successfully"])
    else
      error_response(@deal.errors)
    end
  end

  private
  def set_deal
    @deal = Deal.find_by_id(params[:id])
    error_response(["Deal Not Found"]) if @deal.blank?
  end

  def deal_params
    params.require(:deal).permit(
      :organization_id,
      :title,
      :client_name,
      :transaction_type,
      :deal_size,
      :projected_close_date,
      :completion_percent,
      :status,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:deal].blank?
      error_response(["Deal related parameters not found."])
    end
  end
end
