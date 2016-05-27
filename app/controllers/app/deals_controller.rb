class App::DealsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.is_super?
      deals = Deal.all.includes(:users, :starred_deals)
    elsif current_user.is_organzation_admin?(current_user.organization.try(:id))
      deals = current_user.organization.deals.includes(:users, :starred_deals)
    else
      deals = current_user.deals.includes(:users, :starred_deals)
    end

    @deals = format_deals_for_display(deals)
  end

  def show
    @deal = Deal.find(params[:id])
    redux_store('doxlyStore', props: {deal: @dore})
  end

  private

  # This method will add the collaborators attribute, the starred attribute
  # and will group the deals together
  def format_deals_for_display deals
    deals = deals.map {|deal| deal.attributes.merge({collaborators: deal.users, 
                                                     starred: deal.starred_deals.where(user_id: current_user.id).present? })}

    grouped = deals.group_by {|deal| DateTime.parse(deal["projected_close_date"].to_s).strftime("%B %Y")}

    grouped.keys.map {|key| {heading: key, deals: grouped[key]}}
  end
end