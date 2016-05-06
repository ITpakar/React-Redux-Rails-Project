class OrganizationsController < ApplicationController
  respond_to :json

  before_action :authenticate_super_admin, only: [:index]
  before_action :authenticate_organization_admin, only: [:update, :destroy]
  before_action :set_organization, only: [:update, :destroy]

  skip_before_action :verify_authenticity_token

  def index
    organizations = Organization.all
    success_response(
      {
        organizations: organizations.map(&:to_hash)
      }
    )
  end

  def update
    if @organization.update(organization_params)
      success_response(
        {
          organization: organization.to_hash
        }
      )
    else
      error_response(@organization.errors)
    end
    return
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
    return
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
end
