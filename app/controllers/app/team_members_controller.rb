class App::TeamMembersController < App::ApplicationController
  def index
  	@team = current_user.organization_user.organization.organization_users
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
      organization_user.attributes.merge({
      	active_deal_count: org_user.deals.active.count,
      	completed_deal_count: org_user.deals.complete.count
      });
    end
  end
end