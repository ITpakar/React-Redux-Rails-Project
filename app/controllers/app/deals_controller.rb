class App::DealsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.is_super?
      deals = Deal.all.includes(:users)
    elsif current_user.is_organzation_admin?(current_user.organization.try(:id))
      deals = current_user.organization.deals.includes(:users)
    else
      deals = current_user.deals.includes(:users)
    end

    deals = deals.map {|deal| deal.attributes.merge({collaborators: deal.users})}

    grouped = deals.group_by {|deal| DateTime.parse(deal["projected_close_date"].to_s).strftime("%B %Y")}

    @deals = grouped.keys.map {|key| {heading: key, deals: grouped[key]}}
  end

  def show
    @deal = Deal.find(params[:id])
  end
end