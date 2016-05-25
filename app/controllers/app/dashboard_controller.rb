class App::DashboardController < ApplicationController
  def index
    deal_stats = current_user.deal_stats
  end
end