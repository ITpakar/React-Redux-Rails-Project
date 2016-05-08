class DealCollaboratorsController < ApplicationController
  respond_to :json

  before_action :authentication_deal_collaborator!, only: [:index]
  before_action :authentication_org_deal_admin!, only: [:create, :destroy]
  before_action :set_deal
  before_action :set_deal_collaborator, only: [:destroy]
  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    @deal_collaborators = DealCollaborator.order("#{sortby} #{sortdir}")
                                          .page(@page)
                                          .per(@per_page) rescue []
    success_response(
      {
        deal_collaborators: @deal_collaborators.map(&:to_hash)
      }
    )
  end

  def create
    @deal_collaborator = @deal.deal_collaborators.new(
      user_id: params[:user_id],
      added_by: current_user.id
    )
    if @deal_collaborator.save
      success_response(["Deal Collaborator created successfully."])
    else
      error_response(@deal_collaborator.errors)
    end
  end

  def destroy
    if @deal_collaborator.destroy
      success_response(["Deal Collaborator destroyed successfully"])
    else
      error_response(@deal_collaborator.errors)
    end
  end

  private
  def set_deal
    @deal = Deal.find_by_id(params[:deal_id])
    error_response(["Deal Not Found."]) if @deal.blank?
  end

  def set_deal_collaborator
    @deal_collaborator = @deal.deal_collaborators.find_by_id(params[:id])
    error_response(["Deal Collaborator Not Found."]) if @deal_collaborator.blank?
  end
end
