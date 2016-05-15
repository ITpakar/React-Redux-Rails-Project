class DocumentsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_document, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    sortby      = params[:sortby] || ''
    sortdir     = params[:sortdir] || ''
    org_id      = []
    deals_id    = []
    sections_id = []
    tasks_id    = []
    folders_id  = []
    deep        = (params[:deep] == 'true' ? true :false)

    if !params[:org_id].blank?
      if current_user.is_super?
        deals_id = Deal.where("organization_id = ?", org_id).pluck(:id)
      else
        deals_id = current_user.deals.where("organization_id = ? and activated = ?", org_id, true).pluck(:id)
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
        tasks_id = Task.where("(deal_id in (?) or section_id in (?)) and (created_by = ? or assignee_id = ?)", deals_id, sections_id, current_user.id, current_user.id)
      end
    end

    if tasks_id.blank? and !params[:task_id].blank?
      tasks_id = [params[:task_id]]
    end

    if deep and !tasks_id.blank?
      if current_user.is_super?
        folders_id = Folder.where("(parent_type = 'Deal' and parent_id in (?)) or " +
                                  "(parent_type = 'Section' and parent_id in (?)) or " +
                                  "(parent_type = 'Task' and parent_id in (?))",
                                  deals_id, sections_id, tasks_id
                                  ).pluck(:id)
      else
        folders_id = current_user.folders.where("(parent_type = 'Deal' and parent_id in (?)) or " +
                                                "(parent_type = 'Section' and parent_id in (?)) or " +
                                                "(parent_type = 'Task' and parent_id in (?))",
                                                deals_id, sections_id, tasks_id
                                                ).pluck(:id)
      end
    end

    if folders_id.blank? and !params[:folder_id].blank?
      folders_id = [params[:folder_id]]
    end

    @documents = []
    if !deals_id.blank? or !sections_id.blank? or !tasks_id.blank? or !folders_id.blank?
      @documents = Document.where(
                      "(parent_type = 'Deal' and parent_id in (?)) or " +
                      "(parent_type = 'Section' and parent_id in (?)) or " +
                      "(parent_type = 'Task' and parent_id in (?)) or " +
                      "(parent_type = 'Folder' and parent_id in (?))",
                      deals_id, sections_id, tasks_id, folders_id
                    ).order("#{sortby} #{sortdir}")
                     .page(@page)
                     .per(@per_page) rescue []
    end
    success_response(
      {
        documents: @documents.map(&:to_hash)
      }
    )
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      success_response(["Document created successfully."])
    else
      error_response(@document.errors)
    end
  end

  def update
    if @document.update(document_params)
      success_response(["Document updated successfully"])
    else
      error_response(@document.errors)
    end
  end

  def show
    success_response(
      {
        document: @document.to_hash
      }
    )
  end

  def destroy
    if @document.destroy
      success_response(["Document destroyed successfully"])
    else
      error_response(@document.errors)
    end
  end

  private
  def set_document
    @document = Document.find_by_id(params[:id])
    error_response(["Document Not Found"]) if @document.blank?
  end

  def document_params
    params.require(:document).permit(
      :file_name,
      :file_size,
      :file_type,
      :file_uploaded_at,
      :parent_type,
      :parent_id,
      :created_by,
      :activated
    )
  end

  protected
  def ensure_params_exist
    if params[:document].blank?
      error_response(["Document related parameters not found."])
    end
  end
end
