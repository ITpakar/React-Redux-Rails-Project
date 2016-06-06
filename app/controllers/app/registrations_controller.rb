class App::RegistrationsController < Devise::RegistrationsController
  def new
  end

  def create
    # Create the user
    user = User.new(user_params)
    user.activated = true
    user.role = "Normal"

    unless user.save
      warden.custom_failure!
      flash[:errors] = user.errors
      redirect_to new_app_user_registration_path
      return
    end

    # Check to see if the user belongs to an organization
    organization = Organization.find_by_email_domain(user.email_domain)

    # TODO check for an organization invite here

    if organization
      # Create organization user
      OrganizationInternalUser.create(user_id: user.id, organization_id: organization.id)

      # TODO if the email domain doesn't match the orgs email domain (like in the case 
      # of an invite being accepted), then create an OrganizationExternalUser
    else
      # If there's no organization with that email domain
      # then we need to create it
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