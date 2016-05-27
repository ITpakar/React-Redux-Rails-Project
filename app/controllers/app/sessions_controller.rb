class App::SessionsController < Devise::SessionsController
  respond_to :html

  before_action :ensure_params_exist, only: [:create]

  def new
  end

  def create
    resource = User.find_for_database_authentication(
      email: params[:user][:email]
    )

    if resource and resource.valid_password?(params[:user][:password])
      sign_in("user", resource)
      redirect_to app_dashboard_path
    else
      flash[:error] = "Incorrect login or password"
      render 'new'
    end
  end

  def destroy
    sign_out(current_user)
  end

  protected
  def ensure_params_exist
    if params[:user].blank?
      flash[:error] = "Incorrect login or password"
      render 'new'
    end
  end
end