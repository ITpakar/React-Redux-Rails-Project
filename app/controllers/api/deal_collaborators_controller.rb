class Api::DealCollaboratorsController < ApplicationController
  respond_to :json

  before_action :set_deal

  before_action only: [:index, :find] do
    authorize! :read, @deal
  end

  before_action only: [:create, :destroy] do
    authorize! :update, @deal
  end

  # before_action :authenticate_deal_collaborator!, only: [:index]
  before_action :authenticate_org_deal_admin!, only: [:create, :destroy]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal_collaborator, only: [:destroy]

  swagger_controller :deal_collaborators, "Deal Collaborator"

  def self.add_deal_collaborator_params(deal_collaborator)
    deal_collaborator.param :form, "deal_collaborator[user_id]", :integer, :required, "User id"
  end

  swagger_api :index do
    notes "Permissions: Deal Collaborators"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "List of deal_collaborators records", :deal_collaborators
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :create do |deal_collaborator|
    notes "Permissions: Deal Admin, Organization Admin"
    param :path, :deal_id, :integer, :required, "Deal Id"
    DealCollaboratorsController::add_deal_collaborator_params(deal_collaborator)
    response :success, "Deal Collaborator created successfully.", :deal_collaborator
    response :bad_request, "Incorrect request/formdata"
  end

  swagger_api :destroy do
    notes "Permissions: Deal Admin, Organization Admin"
    param :path, :deal_id, :integer, :required, "Deal Id"
    param :path, :user_id, :integer, :optional, "User Id"
    param :path, :id, :integer, :required, "Id"
    response :success, "Deal Collaborator destroyed successfully"
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  def index
    json = []

    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''

    collaborators = @deal.collaborators.order("#{sortby} #{sortdir}").page(@page).per(@per_page) rescue []
    collaborators.each do |user|
      user_h = user.to_hash
      user_h[:organization_user_id] = user.organization_user.id

      json << user_h
    end

    collaborators = @deal.deal_collaborator_invites rescue []
    collaborators.each do |user|
      user_h = user.to_hash

      json << user_h
    end

    success_response(
      {
        collaborators: json
      }
    )
  end

  def create
    @deal_collaborator = @deal.deal_collaborators.new(
      user_id: params[:deal_collaborator][:user_id],
      added_by: current_user.organization_user.id
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

  def find
    collaborator_identifier = params[:collaborator_identifier]

    candidates = User.where("users.id NOT IN (?)", @deal.collaborators.pluck(:id))

    found = false
    collaborator = nil

    candidates.each do |candidate|
      if collaborator_identifier.include? "@"
        # Find by email
        if candidate.email == collaborator_identifier
          collaborator = candidate
          break
        end
      else
        # Find by name
        if candidate.name == collaborator_identifier
          collaborator = candidate
          break
        end
      end
    end

    if collaborator.present?
      success_response({
        collaborator: collaborator.to_hash
        }
      )
    elsif DealCollaboratorInvite.where('deal_id = ? and email = ?', @deal, collaborator_identifier).present?
      error_response(["Collaborator already invited."])
    elsif collaborator_identifier.include? "@"
      user = User.new(email: collaborator_identifier, first_name: collaborator_identifier)
      success_response({
        collaborator: user.to_hash
        }
      )
    else
      error_response(["Collaborator not found."])
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

  protected
  def ensure_params_exist
    if params[:deal_collaborator].blank?
      error_response(["Deal Collaborator related parameters not found."])
    end
  end
end
