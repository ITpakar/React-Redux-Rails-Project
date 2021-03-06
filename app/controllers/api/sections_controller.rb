class Api::SectionsController < ApplicationController
  respond_to :json

  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal
  before_action :set_section, only: [:show, :update, :destroy]

  before_action only: [:show, :tree] do
    authorize! :read, @deal
  end

  before_action only: [:create, :update, :destroy] do
    authorize! :update, @deal
  end

  swagger_controller :sections, "Section"

  def self.add_section_params(section)
    section.param :form, "section[name]", :string, :required, "Name"
    section.param :form, "section[activated]", :boolean, :optional, "Activated"
  end

  swagger_api :index do
    notes "Permissions: Deal Collaborators"
    param :query, :category_id, :integer, :optional, "Category Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "List of sections records", :section
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :trees do
    notes "Permissions: Deal Collaborators"
    param :query, :category_id, :integer, :optional, "Category Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "List of sections with related information in tree", :sections
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :show do
    notes "Permissions: Deal Collaborators"
    param :path, :id, :integer, :required, "Section Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "Section record", :section
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :create do |section|
    notes "Permissions: Deal Collaborators"
    SectionsController::add_section_params(section)
    param :form, "section[category_id]", :integer, :required, "Category Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "Section created successfully", :section
    response :bad_request, "Incorrect request/formdata"
  end

  swagger_api :update do |section|
    notes "Permissions: Deal Collaborators"
    SectionsController::add_section_params(section)
    param :path, :id, :integer, :required, "Section Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "Section updated successfully", :section
    response :unauthorized, "You are unauthorized to access this page."
    response :bad_request, "Incorrect request/formdata"
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :destroy do
    notes "Permissions: Deal Admin and Section Owner"
    param :path, :id, :integer, :required, "Section Id"
    param :path, :deal_id, :integer, :required, "Deal Id"
    response :success, "Section destroyed successfully"
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    @category_id = params[:category_id]
    conditions = []
    conditions[0] = ["category_id = ?", "#{@category_id}"] if @category_id
    @sections = @deal.sections
                     .where(conditions[0])
                     .order("#{sortby} #{sortdir}")
                     .page(@page)
                     .per(@per_page) rescue []
    success_response(
      {
        sections: @sections.map(&:to_hash)
      }
    )
  end

  def trees
    scope = @deal.sections.order("name ASC")
    category_id = params[:category_id]
    if category_id.present?
      scope = scope.where(:category_id => category_id)
    end

    can_update = can?(:update, @deal)

    results = []
    scope.each do |section|
      tasks = []
      section_h = {}
      section_h[:id] = section.id
      section_h[:type] = section.class.name
      section_h[:title] = section.name
      section_h[:comments_count] = section.comments.count
      section_h[:elements] = tasks
      section_h[:can_update] = can_update

      section.tasks.order("title").each do |task|
        task_elements = []
        task_h = {}
        task_h[:id] = task.id
        task_h[:type] = task.class.name
        task_h[:title] = task.title
        task_h[:status] = task.status
        task_h[:description] = task.description
        task_h[:section_id] = task.section_id
        task_h[:assignee_id] = task.assignee_id
        task_h[:comments_count] = task.comments.count
        task_h[:elements] = task_elements
        task_h[:can_update] = can_update

        task.documents.select("DISTINCT documents.*").order("title").each do |document|
          document_h = document.to_hash
          document_h[:id] = document.id
          document_h[:type] = document.class.name
          document_h[:can_update] = can_update
          task_elements << document_h
        end

        task.folders.order("name").each do |folder|
          folder_elements = []
          folder_h = {}
          folder_h[:id] = folder.id
          folder_h[:type] = folder.class.name
          folder_h[:title] = folder.name
          folder_h[:task_id] = folder.task_id;
          folder_h[:comments_count] = folder.comments.count
          folder_h[:elements] = folder_elements
          folder_h[:can_update] = can_update

          folder.documents.select("DISTINCT documents.*").order("title").each do |document|
            document_h = document.to_hash
            document_h[:id] = document.id
            document_h[:type] = document.class.name
            document_h[:can_update] = can_update
            folder_elements << document_h
          end

          task_elements << folder_h
        end

        tasks << task_h
      end

      results << section_h
    end

    success_response(
      {
        sections: results
      }
    )
  end

  def create
    @section = @deal.sections.new(section_params)
    @section.created_by = current_user.id
    if @section.save
      success_response(
        {
          section: @section.to_hash
        }
      )
    else
      error_response(@section.errors)
    end
  end

  def update
    if @section.update(section_params)
      success_response(
        {
          section: @section.to_hash
        }
      )
    else
      error_response(@section.errors)
    end
  end

  def show
    success_response(
      {
        section: @section.to_hash
      }
    )
  end

  def destroy
    if @section.destroy
      success_response(["Section destroyed successfully"])
    else
      error_response(@section.errors)
    end
  end

  private
  def set_deal
    @deal = Deal.find_by_id(params[:deal_id])
    error_response(["Deal Not Found."]) if @deal.blank?
  end

  def set_section
    @section = @deal.sections.find_by_id(params[:id])
    error_response(["Section Not Found."]) if @section.blank?
  end

  def section_params
    params.require(:section).permit(
      :name,
      :deal_id,
      :category_id,
      :created_by,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:section].blank?
      error_response(["Section related parameters not found."])
    end
  end
end
