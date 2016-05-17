class AccountsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!, except: [:create]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_user, only: [:destroy, :update]
  skip_before_action :verify_authenticity_token

  swagger_controller :account, "Account"

  def self.add_account_params(user)
    user.param :form, "user[email]",      :string, :required,  "Email"
    user.param :form, "user[password]",   :string, :required,  "password"
    user.param :form, "user[first_name]", :string, :optional, "First Name"
    user.param :form, "user[last_name]",  :string, :optional, "Last Name"
    user.param :form, "user[phone]",      :string, :optional, "Phone"
    user.param :form, "user[address]",    :string, :optional, "Address"
    user.param :form, "user[company]",    :string, :optional, "Company"
  end

  swagger_api :index do
    notes "Get self user Details"
    response :success, "user record", :user
    response :unauthorized, "You are unauthorized to access this page."
    response :not_acceptable, "Error with your login or password"
  end

  swagger_api :create do |user|
    notes "Create user"
    AccountsController::add_account_params(user)
    response :success, "User created successfully.", :user
    response :not_acceptable, "Error with your login or password"
  end

  swagger_api :update do |user|
    notes "Update an self user"
    AccountsController::add_account_params(user)
    response :success, "User updated successfully", :user
    response :unauthorized, "You are unauthorized to access this page."
    response :not_acceptable, "Error with your login or password"
  end

  swagger_api :destroy do
    notes "Delete self user"
    response :success,"User destroyed successfully"
    response :unauthorized, "You are unauthorized to access this page."
    response :not_acceptable, "Error with your login or password"
  end

  def index
    success_response(
      {
        user: current_user.to_hash(false)
      }
    )
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    if @user.save
      success_response(["User created successfully."])
    else
      error_response(@user.errors)
    end
  end

  def update
    if @user.update(user_params)
      success_response(["User updated successfully"])
    else
      error_response(@user.errors)
    end
  end

  def destroy
    if @user.destroy
      success_response(["User destroyed successfully"])
    else
      error_response(@user.errors)
    end
  end

  private
  def set_user
    @user = current_user
    error_response(["User Not Found"]) if @user.blank?
  end

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

  protected
  def ensure_params_exist
    if params[:user].blank?
      error_response(["User related parameters not found."])
    end
  end

end
