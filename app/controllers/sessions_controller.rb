class SessionsController < Devise::SessionsController
  respond_to :json

  before_action :ensure_params_exist, only: [:create]
  skip_before_action :verify_authenticity_token

  swagger_controller :sessions, "Sessions"

  swagger_api :create do
    summary "Logged in"
    param :form, "user[email]", :string, :required, "Email"
    param :form, "user[password]", :string, :required, "Password"
    response :success, "Logged in user record", :user
    response :not_acceptable, "Error with your login or password"
  end

  swagger_api :destroy do
    summary "Log out"
    response :no_content
    response :not_acceptable, "Error with your login or password"
  end

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

  def destroy
    sign_out(current_user)
  end

  protected
  def ensure_params_exist
    if params[:user].blank?
      error_response(["Error with your login or password"])
    end
  end
end