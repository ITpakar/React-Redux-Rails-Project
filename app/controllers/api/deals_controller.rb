class Api::DealsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :authenticate_organization_member!, only: [:create]
  before_action :authenticate_org_deal_admin!, only: [:update, :destroy]

  before_action only: [:show] do
    authorize! :update, @deal
  end

  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal, only: [:update, :destroy, :show, :collaborators]

  swagger_controller :deal, "deal"

  def self.add_deal_params(deal)
    deal.param :form, "deal[title]", :string, :required, "Title"
    deal.param :form, "deal[client_name]", :string, :required, "Client Name"
    deal.param :form, "deal[transaction_type]", :string, :required, "Transaction Type"
    deal.param :form, "deal[deal_size]", :string, :optional, "Deal Size"
    deal.param :form, "deal[projected_close_date]", :date, :optional, "Projected Close Date"
    deal.param :form, "deal[completion_percent]", :float, :optional, "Completion Percent"
    deal.param :form, "deal[status]", :string, :required, "Status"
    deal.param :form, "deal[activated]", :boolean, :optional, "Activated"
  end

  swagger_api :index do
    notes "Permissions: Organization Member"
    param :query, :organization_id, :integer, :optional, "Organization Id"
    response :success, "List of accessible deal records", :deal
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :show do
    notes "Permissions: Deal Collaborators"
    param :path, :id, :integer, :required, "deal Id"
    response :success, "Deal record", :deal
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :create do |deal|
    notes "Permissions: Organization Member"
    DealsController::add_deal_params(deal)
    param :form, "deal[organization_id]", :integer, :required, "Organization Id"
    response :success, "Deal created successfully.", :deal
    response :bad_request, "Incorrect request/formdata"
  end

  swagger_api :update do |deal|
    notes "Permissions: Deal Admin, Organization Admin"
    DealsController::add_deal_params(deal)
    param :path, :id, :integer, :required, "deal Id"
    response :success, "Deal updated successfully", :deal
    response :unauthorized, "You are unauthorized to access this page."
    response :bad_request, "Incorrect request/formdata"
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :destroy do
    notes "Permissions: Deal Admin, Organization Admin"
    param :path, :id, :integer, :required, "deal Id"
    response :success, "Deal destroyed successfully"
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    org_id  = params[:organization_id]
    conditions  = []
    conditions << ["organization_id = ?", "#{org_id}"] if org_id
    if current_user.is_super?
      @deals = Deal.where(conditions[0])
                   .order("#{sortby} #{sortdir}")
                   .page(@page)
                   .per(@per_page) rescue []
    elsif current_user.is_organization_admin?(current_user.organization.try(:id))
      @deals = current_user.organization
                           .deals
                           .where(conditions[0])
                           .order("#{sortby} #{sortdir}")
                           .page(@page)
                           .per(@per_page) rescue []
    else
      @deals = current_user.deals
                           .where(conditions[0])
                           .order("#{sortby} #{sortdir}")
                           .page(@page)
                           .per(@per_page) rescue []
    end
    success_response(
      {
        deals: @deals.map(&:to_hash)
      }
    )
  end

  def create
    @deal = Deal.new(deal_params)
    @deal.organization_user_id = current_user.organization_user.id
    if @deal.save
      success_response(
        {
          deal: @deal.to_hash,
          redirect_to: app_deal_path(@deal)
        }
      )
    else
      error_response(@deal.errors)
    end
  end

  def update
    if @deal.update(deal_params)
      if params[:deal][:collaborators]
        params[:deal][:collaborators].each do |i, collaborator|
          user = User.find_by_id(collaborator[:id]) || User.find_by_email(collaborator[:id])
          if user.present?
            @deal.add_collaborator!(user.organization_user, current_user.organization_user)
          else
            deal_collaborator_invite = @deal.invite_collaborator(collaborator[:id], current_user.organization_user)
            InvitationMailer.collaborator_invitation_email(deal_collaborator_invite).deliver_later if deal_collaborator_invite.present?
          end
        end
        @deal.clear_collaborators(params[:deal][:collaborators].map { |key, value| value[:id] })
      end
      success_response(
      {
        deal: @deal.to_hash,
        redirect_to: app_deal_path(@deal)
      }
    )
    else
      error_response(@deal.errors)
    end
  end

  def show
    success_response(
      {
        deal: @deal.to_hash
      }
    )
  end

  def destroy
    if @deal.destroy
      success_response(["Deal destroyed successfully"])
    else
      error_response(@deal.errors)
    end
  end

  def collaborators
    collaborators = @deal.collaborators
    success_response(
      {
        deals: @collaborators.map(&:to_hash)
      }
    )
  end

  def summary
    time = params[:time].try(:downcase)
    time = "6_months" unless ["6_months", "3_months", "1_month"].include?(time)
    by = params[:by].try(:downcase)
    by = "size" unless ["member", "size", "type"].include?(by)


    start_of_month = Time.now.beginning_of_month
    scope = Deal.where(:activated => true)

    if time == "1_month"
      start_time = start_of_month - 1.month
      end_time = start_time.end_of_month
    elsif time == "3_months"
      start_time = start_of_month - 3.months
      end_time = (start_time + 2.months).end_of_month
    else
      start_time = start_of_month - 6.months
      end_time = (start_time + 5.months).end_of_month
    end

    scope = scope.where("deals.created_at BETWEEN ? AND ?", start_time, end_time)
    if by == "size"
      if time == "1_month"
        scope = scope.group("1, 2")
                     .select("deal_size, TO_CHAR(deals.created_at, 'YYYY-MM-DD') AS date, COUNT(*) AS count")
      else
        scope = scope.group("1, 2")
                     .select("deal_size, TO_CHAR(deals.created_at, 'YYYY-MM') AS date, COUNT(*) AS count")
      end
    elsif by == "type"
      if time == "1_month"
        scope = scope.group("1, 2")
                     .select("transaction_type, TO_CHAR(deals.created_at, 'YYYY-MM-DD') AS date, COUNT(*) as count")
      else
        scope = scope.group("1, 2")
                     .select("transaction_type, TO_CHAR(deals.created_at, 'YYYY-MM') AS date, COUNT(*) as count")
      end
    else
      scope = scope.joins(:organization_user)
                   .group(:user_id)
                   .select("user_id, COUNT(*) as count")
    end

    json = {}
    json[:results] = scope.as_json(:except => [:id])

    if by == "size"
      json[:sizes] = json[:results].collect{|h| h["deal_size"]}
    elsif by == "type"
      json[:types] = Deal::TRANSACTION_TYPES
    else
      json[:members] = []
      json[:results].collect{|h|
        user = User.find(h["user_id"])
        json[:members].push(user.to_hash)
      }
    end

    unless by == "member"
      group_values = []
      if time == "1_month"
        group_values = (start_time.to_date..end_time.to_date).to_a.collect{|d| d.strftime("%Y-%m-%d")}
      else
        i = 0
        begin
          d = start_time + i.month
          group_values.push(d.strftime("%Y-%m"))
          i += 1
        end while d < (end_time - 1.month)
      end

      json[:group_values] = group_values
    end
    success_response(json)
  end

  private
  def set_deal
    @deal = Deal.find_by_id(params[:id])
    error_response(["Deal Not Found"]) if @deal.blank?
  end

  def deal_params
    params.require(:deal).permit(
      :organization_id,
      :title,
      :client_name,
      :transaction_type,
      :deal_size,
      :projected_close_date,
      :status,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:deal].blank?
      error_response(["Deal related parameters not found."])
    end
  end
end
