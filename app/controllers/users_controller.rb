class UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_super_admin!

  def index
    @users = User.page(@page).per(@per_page) rescue []
    success_response(
      {
        users: @users.map(&:to_hash)
      }
    )
  end
end