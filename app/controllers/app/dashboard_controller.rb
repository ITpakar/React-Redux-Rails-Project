class App::DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @deal_stats = current_user.deal_stats
    @recently_updated_files = current_user.recently_updated_files
    @deals_behind_schedule = current_user.displayed_deals.behind_schedule
    @deals_nearing_completion = current_user.displayed_deals.nearing_completion
  end
end