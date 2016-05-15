class OrganizationsController < ApplicationController
  respond_to :json

  before_action :authenticate_super_admin!, only: [:index, :create]
  before_action :authenticate_organization_admin!, only: [:update, :destroy]
  before_action :authenticate_organization_member!, only: [:show]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_organization, only: [:update, :destroy, :show]
  before_action :set_peginate, only: [:index]

  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    @organizations = Organization.order("#{sortby} #{sortdir}").page(@page).per(@per_page) rescue []
    success_response(
      {
        organizations: @organizations.map(&:to_hash)
      }
    )
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      @organization.organization_users.create(
        user_id: current_user.id,
        user_type: ORG_USER_TYPE_ADMIN
      )
      success_response(
        {
          organization: @organization.to_hash
        }
      )
    else
      error_response(@organization.errors)
    end
  end

  def show
    success_response(
      {
        organization: @organization.to_hash
      }
    )
  end

  def update
    if @organization.update(organization_params)
      success_response(
        {
          organization: @organization.to_hash
        }
      )
    else
      error_response(@organization.errors)
    end
  end

  def destroy
    if @organization.destroy
      success_response(
        {
          message: "Organization destroyed successfully"
        }
      )
    else
      error_response(@organization.errors)
    end
  end

  private
  def set_organization
    @organization = Organization.find_by_id(params[:id])
    error_response(["Organization Not Found."]) if @organization.blank?
  end

  def organization_params
    params.require(:organization).permit(
      :name,
      :email_domain,
      :phone,
      :address,
      :created_by,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:organization].blank?
      error_response(["Organization related parameters not found."])
    end
  end
end
