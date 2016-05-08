class OrganizationUsersController < ApplicationController
  respond_to :json

  before_action :authenticate_organization_admin!
  before_action :set_organization
  before_action :set_organization_user, only: [:destroy]
  skip_before_action :verify_authenticity_token

  def index
    @organization_users = @organization.users.page(@page).per(@per_page) rescue []
    success_response(
      {
        
        organization_users: @organization_users.map(&:to_hash)
      }
    )
  end

  def destroy
    if @organization_user.destroy
      success_response(
        {
          message: "User destroyed from organization successfully."
        }
      )
    else
      error_response(@organization.errors)
    end
  end



  private
  def set_organization
    @organization = Organization.find_by_id(params[:organization_id])
    error_response(["Organization Not Found."]) if @organization.blank?
  end

  def set_organization_user
    @organization_user = @organization.organization_users.find_by_id(params[:id])
    error_response(["User Not Found in Organization."]) if @organization_user.blank?
  end
end
