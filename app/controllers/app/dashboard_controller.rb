class App::DashboardController < App::ApplicationController
  before_action :authenticate_user!

  def index
    @deal_stats = current_user.context.deal_stats
    @recently_updated_files = current_user.context.recently_updated_files
    @deals_behind_schedule = current_user.context.deals.behind_schedule
    @deals_nearing_completion = current_user.context.deals.nearing_completion

    @events = current_user.context.events.first(15)
  end

  def settings
    # This is weird, somehow the 'Settings were not saved' message
    # is always appears when visit this page
    flash[:error] = nil
  end

  def save_settings
    @user = current_user
    password = params[:user][:password]
    @user.assign_attributes(setting_params)
puts "Line 17 #{password.inspect} #{setting_params.inspect}"

    if @user.valid_password?(password)
      if @user.save
        flash[:notice] = "Settings was saved"
        redirect_to app_settings_path
        return
      end
    else
      @user.errors.add(:password, "is not valid")
    end

    flash[:error] = "Settings were not saved"
    render :action => :settings
  end

  private

  def setting_params
    params.require(:user).permit(:first_name, :last_name, :company, :email)
  end
end
