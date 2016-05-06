class RegistrationsController < Devise::SessionsController
  respond_to :json

  skip_before_filter :verify_authenticity_token

  def create
    user = User.new(user_params)
    user.skip_confirmation!
    if user.save
      success_response(
        {
          user: resource.to_hash
        }
      )
    else
      warden.custom_failure!
      error_response(user.errors)
    end
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
      :company
    )
  end
end
