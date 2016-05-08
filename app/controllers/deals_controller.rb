class DealsController < ApplicationController
  respond_to :json

  before_action :authenticate_organization_member!, only: [:create]
  before_action :authentication_org_deal_admin!, only: [:update, :destroy]
  before_action :authentication_deal_collaborator!, only: [:show]
  before_action :set_deal, only: [:update, :destroy, :show]
  skip_before_action :verify_authenticity_token


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
    if @deal
      success_response(
        {
          deal: @deal.to_hash
        }
      )
    end
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
end
