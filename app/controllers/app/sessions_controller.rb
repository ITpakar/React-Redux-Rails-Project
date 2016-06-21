class App::SessionsController < Devise::SessionsController
  respond_to :html

  before_action :ensure_params_exist, only: [:create]

  def new
    super
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
    super
  end

  protected
  def ensure_params_exist
    if params[:user].blank?
      flash[:error] = "Incorrect login or password"
      render 'new'
    end
  end

  def sign_in(resource_or_scope, *args)
    options  = args.extract_options!
    scope    = Devise::Mapping.find_scope!(resource_or_scope)
    resource = args.last || resource_or_scope

    expire_data_after_sign_in!
    if options[:bypass]
      warden.session_serializer.store(resource, scope)
    elsif warden.user(scope) == resource && !options.delete(:force)
      # Do nothing. User already signed in and we are not forcing it.
      true
    else
      warden.set_user(resource, options.merge!(scope: scope))
    end
  end
  
  def require_no_authentication
    if current_user
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end