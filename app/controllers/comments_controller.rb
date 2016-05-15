class CommentsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :is_deal_collaborator?, only: [:update, :destroy, :show, :create]
  skip_before_action :verify_authenticity_token

  def index
    sortby       = params[:sortby] || ''
    sortdir      = params[:sortdir] || ''
    # deal_id      = params[:deal_id]
    task_id      = params[:task_id]
    document_id  = params[:document_id]
    user_id      = params[:user_id] || current_user.id
    comment_type = params[:comment_type]
    conditions  = []
    conditions << ["task_id = ?", "#{task_id}"] if task_id
    conditions << ["user_id = ?", "#{user_id}"] if user_id
    conditions << ["document_id = ?", "#{document_id}"] if document_id
    conditions << ["comment_type = ?", "#{comment_type}"] if comment_type

    @comments = Comment.where(conditions[0])
                       .order("#{sortby} #{sortdir}")
                       .page(@page)
                       .per(@per_page) rescue []
    success_response(
      {
        comments: @comments.map(&:to_hash)
      }
    )
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      success_response(["Comment created successfully."])
    else
      error_response(@comment.errors)
    end
  end

  def show
    success_response(
      {
        comment: @comment.to_hash
      }
    )
  end

  def update
    if @comment.update(comment_params)
      success_response(["Comment updated successfully"])
    else
      error_response(@comment.errors)
    end
  end

  def destroy
    if @comment.destroy
      success_response(["Comment destroyed successfully"])
    else
      error_response(@comment.errors)
    end
  end

  private
  def set_comment
    @comment = Comment.find_by_id(params[:id])
    error_response(["Comment Not Found"]) if @comment.blank?
  end

  def comment_params
    params.require(:comment).permit(
      :user_id,
      :deal_id,
      :task_id,
      :document_id,
      :comment_type,
      :comment
    )
  end

  def is_deal_collaborator?
    if @comment.blank?
      @task = Task.find_by_id(params[:comment][:task_id])
      @section = @task.section.first if @task
      @deal = @section.deal if @section
    else
      @deal = @comment.task.section.deal
    end

    if !@deal.blank?
      return if current_user.is_deal_collaborator?(@deal.id) or
                current_user.is_org_deal_admin?(@deal.id) or
                current_user.is_comment_owner?(@comment.id)
    else
      error_response(["Deal Not Found for this Comment."])
    end
  end

  protected
  def ensure_params_exist
    if params[:comment].blank?
      error_response(["Comment related parameters not found."])
    end
  end
end
