class FoldersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_folder, only: [:show, :update, :destroy]

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    orgs_id     = []
    deals_id    = []
    sections_id = []
    tasks_id    = []
    deep        = (params[:deep] == 'true' ? true :false)

    if !params[:org_id].blank?
      if current_user.is_super?
        deals_id = Deal.where("organization_id = ?", orgs_id).pluck(:id)
      else
        deals_id = current_user.deals.where("organization_id = ? and activated = ?", orgs_id, true).pluck(:id)
      end
    end

    if deals_id.blank? and !params[:deal_id].blank?
      deals_id = [params[:deal_id]]
    end

    if deep and !deals_id.blank?
      if current_user.is_super?
        sections_id = Section.where("deal_id in (?)", deals_id).pluck(:id)
      else
        sections_id = current_user.sections.where("deal_id in (?) and activated = ?", deals_id, true).pluck(:id)
      end
    end

    if sections_id.blank? and !params[:section_id].blank?
      sections_id = [params[:section_id]]
    end

    if deep and !sections_id.blank?
      if current_user.is_super?
        tasks_id = Task.where("deal_id in (?) or section_id in (?)", deals_id, sections_id).pluck(:id)
      else
        tasks_id = Task.where("(deal_id in (?) or section_id in (?)) and (created_by = ? or assignee_id = ?)", deals_id, sections_id, current_user.id, current_user.id).pluck(:id)
      end
    end

    if tasks_id.blank? and !params[:task_id].blank?
      tasks_id = [params[:task_id]]
    end

    @folders = []
    if !deals_id.blank? or !sections_id.blank? or !tasks_id.blank?
      @folders = Folder.where(
                    "(parent_type = 'Deal' and parent_id in (?)) or " +
                    "(parent_type = 'Section' and parent_id in (?)) or " +
                    "(parent_type = 'Task' and parent_id in (?))",
                    deals_id, sections_id, tasks_id
                  ).order("#{sortby} #{sortdir}")
                   .page(@page)
                   .per(@per_page) rescue []
    end

    success_response(
      {
        sections: @folders.map(&:to_hash)
      }
    )
  end

  def create
    @folder = current_user.folders.new(folder_params)
    if @folder.save
      success_response(["Folder created successfully."])
    else
      error_response(@folder.errors)
    end
  end

  def update
    if @folder.update(folder_params)
      success_response(["Folder updated successfully"])
    else
      error_response(@folder.errors)
    end
  end

  def show
    success_response(
      {
        folder: @folder.to_hash
      }
    )
  end

  def destroy
    if @folder.destroy
      success_response(["Folder destroyed successfully"])
    else
      error_response(@folder.errors)
    end
  end


  private
  def set_folder
    @folder = Folder.find_by_id(params[:id])
    error_response(["Folder Not Found"]) if @deal.blank?
  end

  def folder_params
    params.require(:folder).permit(
      :name,
      :parent_type,
      :parent_id,
      :created_by,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:folder].blank?
      error_response(["Folder related parameters not found."])
    end
  end
end
