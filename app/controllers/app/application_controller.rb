class App::ApplicationController < ApplicationController
  include ReactOnRails::Controller

  after_action :initialize_redux_store

  def add_to_redux_store key, value
    @redux_store_data ||= {}
    @redux_store_data[key] = value;
  end

  def initialize_redux_store
    @redux_store_data ||= {}

    # Data that we need for every page goes here
    # Add starred deals
    if current_user
      starred_deals = StarredDeal.includes(:deal).where(user_id: current_user.id).map {|sd| sd.deal_id}
      add_to_redux_store :starred_deals, starred_deals
    end
    redux_store('doxlyStore', props: @redux_store_data)
  end
end