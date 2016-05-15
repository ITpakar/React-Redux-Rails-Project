class NotificationsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :authenticate_super_admin!, only: [:create, :destroy]
  before_action :authenticate_notification_reciever!, only: [:show, :update]
  before_action :set_notification, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    user_id = params[:user_id] || current_user.id
    status  = params[:status]
    conditions  = []
    conditions << ["status = ?", "#{status.downcase}"] if status and status.to_s != 'all'
    conditions << ["user_id = ?", "#{user_id}"] if user_id
    @notifications = Notification.where(conditions[0])
                       .order("#{sortby} #{sortdir}")
                       .page(@page)
                       .per(@per_page) rescue []
    success_response(
      {
        notifications: @notifications.map(&:to_hash)
      }
    )
  end

  def show
    success_response(
      {
        notification: @notification.to_hash
      }
    )
  end

  def create
    if params[:user_ids] and params[:message]
      params[:user_ids].each do |user_id|
        @notification = Notification.new(
                          message: params[:message],
                          user_id: user_id,
                          status: 'unread'
                        )
        @notification.save
      end
      success_response(["Notification created successfully."])
    else
      error_response(["Notification related parameters not found."])
    end
  end

  def update
    if params[:status] and @notification.update(status: params[:status])
      success_response(["Notification updated successfully"])
    else
      error_response(["Notification status related parameters not found."])
    end
  end

  def destroy
    if @notification.destroy
      success_response(["Notification destroyed successfully"])
    else
      error_response(@notification.errors)
    end
  end

  private
  def set_notification
    @notification = Notification.find_by_id(params[:id])
    error_response(["Notification Not Found"]) if @notification.blank?
  end
end
