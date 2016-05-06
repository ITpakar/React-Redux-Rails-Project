class SessionsController < Devise::SessionsController
  respond_to :json

  before_action :ensure_params_exist
  skip_before_action :verify_authenticity_token

  def create
    resource = User.find_for_database_authentication(
      email: params[:user][:email]
    )

    if resource and resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      success_response(
        {
          user: resource.to_hash
        }
      )
    else
      error_response(["Error with your login or password"])
    end
  end

  protected
  def ensure_params_exist
    if params[:user].blank?
      error_response(["Error with your login or password"])
    end
  end
end