class App::RegistrationsController < Devise::RegistrationsController
  def new
    @user = User.new
    if params[:token]
      invite = DealCollaboratorInvite.find_by_token(params[:token])
      @user.email = invite.email
    end
  end

  def create
    # Create the user
    user = User.new(user_params)
    user.activated = true
    user.role = "Normal"

    unless user.save
      warden.custom_failure!
      flash[:errors] = user.errors
      redirect_to new_app_user_registration_path(token: params[:token])
      return
    end

    # Check to see if the user belongs to an organization
    organization = Organization.find_by_email_domain(user.email_domain)

    # Check to see if the user has any outstanding invites
    # These invites will only get accepted in ConfirmationsController
    # but we need them here to create the organization_user

    invite = DealCollaboratorInvite.where(email: user.email).try(:first)

    if invite
      organization = invite.deal.organization
    end

    if organization
      # Create organization user
      if user.email_domain == organization.email_domain
        OrganizationInternalUser.create(user_id: user.id, organization_id: organization.id)
      else
        OrganizationExternalUser.create(user_id: user.id, organization_id: organization.id)
      end
    else
      # If there's no organization found then we need to create it
      organization = Organization.create(name: user_params[:company], email_domain: user.email_domain, created_by: user.id)
    end

    flash[:notice] = "Please confirm your email address"
    redirect_to after_sign_up_path_for(user)
  end

  private
  def user_params
    params.require(:user).permit(
      :email,
      :password,
      :first_name,
      :last_name,
      :phone,
      :address,
      :company,
      :activated
    )
  end
end