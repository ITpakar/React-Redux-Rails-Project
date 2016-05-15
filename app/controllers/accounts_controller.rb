class AccountsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!, except: [:create]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_user, only: [:destroy, :update]
  skip_before_action :verify_authenticity_token

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
end
