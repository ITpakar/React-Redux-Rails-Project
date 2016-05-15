class TasksController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :is_deal_collaborator?, only: [:update, :destroy, :show, :create]

  def index
    sortby      = params[:sortby] || ''
    sortdir     = params[:sortdir] || ''
    @org_id     = params[:org_id]
    @deal_id    = params[:deal_id]
    @section_id = params[:section_id]
    @assignee_id = params[:assignee_id]

    conditions  = []
    conditions[0] = ["section_id = ?", "#{@section_id}"] if @section_id
    conditions[0] = ["assignee_id = ?", "#{@assignee_id}"] if @assignee_id
    conditions[0] = ["organization_id = ?", "#{@org_id}"] if @org_id
    conditions[0] = ["deal_id = ?", "#{@deal_id}"] if @deal_id

    @tasks = current_user.tasks
                         .where(conditions[0])
                         .order("#{sortby} #{sortdir}")
                         .page(@page)
                         .per(@per_page) rescue []
    success_response(
      {
        tasks: @tasks.map(&:to_hash)
      }
    )
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      success_response(["Task created successfully."])
    else
      error_response(@task.errors)
    end
  end

  def update
    if @task.update(task_params)
      success_response(["Task updated successfully"])
    else
      error_response(@task.errors)
    end
  end

  def show
    success_response(
      {
        task: @task.to_hash
      }
    )
  end

  def destroy
    if @task.destroy
      success_response(["Task destroyed successfully"])
    else
      error_response(@task.errors)
    end
  end

  private
  def set_task
    @task = Task.find_by_id(params[:id])
    error_response(["Task Not Found."]) if @task.blank?
  end

  def is_deal_collaborator?
    if @task.blank?
      @section = Section.find_by_id(params[:task][:section_id])
      @deal = @section.deal if @section
    else
      @deal = @task.section.deal
    end

    if !@deal.blank?
      return current_user.is_deal_collaborator?(@deal.id)
    else
      error_response(["Deal Not Found for this task."])
    end
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :status,
      :section_id,
      :assignee_id,
      :created_by,
      :due_date
    )
  end

  protected
  def ensure_params_exist
    if params[:task].blank?
      error_response(["Task related parameters not found."])
    end
  end
end
