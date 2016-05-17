class RegistrationsController < Devise::SessionsController
  respond_to :json

  skip_before_filter :verify_authenticity_token

  swagger_controller :user, "User"

  def self.add_user_params(user)
    user.param :form, "user[email]", :string, :required, "Email"
    user.param :form, "user[password]", :string, :required, "Password"
    user.param :form, "user[first_name]", :string, :optional, "First Name"
    user.param :form, "user[last_name]", :string, :optional, "Last Name"
    user.param :form, "user[phone]", :string, :optional, "Phone"
    user.param :form, "user[address]", :string, :optional, "Address"
    user.param :form, "user[company]", :string, :optional, "Company"
  end

  swagger_api :create do |user|
    notes "Created user record"
    RegistrationsController::add_user_params(user)
    response :success, "User created successfully.", :user
    response :not_acceptable, "Error with your login or password"
  end

  def create
    user = User.new(user_params)
    user.skip_confirmation!
    if user.save
      success_response(
        {
          user: user.to_hash
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
      :company,
      :activated,
      :role
    )
  end
end
