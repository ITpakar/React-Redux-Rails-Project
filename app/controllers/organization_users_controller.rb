class OrganizationUsersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :authenticate_organization_admin!
  before_action :set_organization
  before_action :ensure_params_exist, only: [:update]
  before_action :set_organization_user, only: [:destroy, :update]
  skip_before_action :verify_authenticity_token

  def index
    @organization_users = @organization.users.page(@page).per(@per_page) rescue []
    success_response(
      {
        
        organization_users: @organization_users.map(&:to_hash)
      }
    )
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user.blank?
      @user = User.new( email: params[:email],
                        password: '12345678',
                        first_name: params[:name],
                        activated: false
                      )
      @user.skip_confirmation!
      @user.save
    end
    @organization_user = OrganizationUser.new(
                          organization_id: current_user.organization.id,
                          user_id: @user.id,
                          invitation_accepted: false,
                          invitation_token: SecureRandom.hex(10)
                         )
    if @organization_user.save and @user
      InvitationMailer.invitation_email(@user, @organization_user).deliver_later
      success_response(["User invited successfully in the organization."])
    else
      error_response(@organization_user.errors)
    end
  end

  def update
    if @organization_user.update(organization_user_params)
      success_response(["User data updated successfully for the organization."])
    else
      error_response(@organization_user.errors)
    end
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

  def organization_user_params
    params.require(:organization_user).permit(
      :organization_id,
      :user_id,
      :user_type,
      :invitation_accepted
    )
  end

  protected
  def ensure_params_exist
    if params[:organization_user].blank?
      error_response(["Organization User related parameters not found."])
    end
  end
end
