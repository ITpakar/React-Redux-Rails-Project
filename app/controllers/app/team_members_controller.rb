class App::TeamMembersController < App::ApplicationController
  def index
  	@team = format_users_for_display(current_user.organization_user.organization.organization_users)
  end

  def update
  end

  def create
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
        avatar_name: org_user.user.avatar_name,
        initials: org_user.user.initials
      });
    end
  end
end