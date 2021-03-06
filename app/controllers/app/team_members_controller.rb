class App::TeamMembersController < App::ApplicationController
  def index
  	@team = format_users_for_display(current_user.organization_user.organization.organization_users)
  end

  def show
    @organization_user = current_organization.organization_users.find(params[:id])
    @deals = format_deals_for_display(@organization_user.deals)
  end

  def update
    @organization_user = current_organization.organization_users.find(params[:id])
    @organization_user.user.update(user_params)
    redirect_to app_team_member_path(@organization_user)
  end

  def create
    InvitationMailer.organization_invitation_email("#{params[:first_name]} #{params[:last_name]}", params[:email], current_organization).deliver_later
    flash[:notice] = "#{params[:first_name]} #{params[:last_name]} successfully invited!"
    redirect_to app_team_members_path
  end

  def destroy
  end

  private
  def format_users_for_display organization_users
    organization_users.map do |org_user|
      org_user.attributes.merge({
      	active_deal_count: org_user.deals.active.count,
      	completed_deal_count: org_user.deals.complete.count,
        name: org_user.user.name,
        email: org_user.user.email,
        avatar: org_user.user.avatar.url,
        initials: org_user.user.initials,
        url: app_team_member_path(org_user)
      });
    end
  end

  def format_deals_for_display deals
    deals = deals.map {|deal| deal.attributes.merge({
      collaborators: deal.organization_users.map{|org_user| org_user.attributes.merge({avatar: org_user.user.avatar.url})}, 
      starred: deal.starred_deals.where(organization_user_id: current_user.organization_user.id).present? })}
    
    grouped = deals.group_by do |deal|
      group = 'Active Deals' if Deal::ACTIVE_STATUSES.include?(deal['status'])
      group = 'Complete Deals' if (Deal::ARCHIVED_STATUSES + Deal::CLOSED_STATUSES).include?(deal['status'])
      group
    end

    grouped.keys.map {|key| {heading: key, deals: grouped[key]}}
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :avatar,
      :avatar_cache
    )
  end
end