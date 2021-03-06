class Api::DocumentsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_document, only: [:show, :update, :destroy, :send_to_docusign, :create_version]

  swagger_controller :document, "Document"

  def self.add_document_params(document)
    document.param :form, "document[title]", :string, :required, "Title"
    document.param :form, "document[file_name]", :string, :optional, "File Name"
    document.param :form, "document[file_size]", :integer, :optional, "File Size"
    document.param :form, "document[file_type]", :string, :optional, "File Type"
    document.param :form, "document[file_uploaded_at]", :datetime, :optional, "File Uploaded At"
    document.param :form, "document[activated]", :boolean, :optional, "Activated"
  end

  swagger_api :index do
    notes "Permissions: Deal Collaborators"
    param :query, :org_id, :integer, :optional, "Organization Id"
    param :query, :deal_id, :integer, :optional, "Deal Id"
    param :query, :section_id, :integer, :optional, "Section Id"
    param :query, :task_id, :integer, :optional, "Task Id"
    param :query, :folder_id, :integer, :optional, "Folder Id"
    param :query, :deep, :boolean, :optional, "Deep"
    response :success, "List of documents records", :document
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :show do
    notes "Permissions: Deal Collaborators"
    param :path, :id, :integer, :required, "Document Id"
    response :success, "Document record", :document
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

  swagger_api :create do |document|
    notes "Permissions: Deal Collaborators"
    DocumentsController::add_document_params(document)
    param :form, "document[parent_type]", :string, :required, "Parent Type"
    param :form, "document[parent_id]", :integer, :required, "Parent Id"
    response :success, "Document created successfully.", :document
    response :bad_request, "Incorrect request/formdata"
  end

  swagger_api :update do |document|
    notes "Permissions: Deal Collaborators"
    DocumentsController::add_document_params(document)
    param :path, :id, :integer, :required, "Document Id"
    response :success, "Document updated successfully", :document
    response :bad_request, "Incorrect request/formdata"
    response :forbidden, "You are unauthorized User"
    response :unauthorized, "You are unauthorized to access this page."
  end

  swagger_api :destroy do
    notes "Permissions: Deal Admin and Document Owner"
    param :path, :id, :integer, :required, "Document Id"
    response :success, "Document destroyed successfully"
    response :unauthorized, "You are unauthorized to access this page."
    response :forbidden, "You are unauthorized User"
  end

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
    file = params[:document][:file]
    name = file.original_filename
    # directory = "#{Rails.public_path.to_s}/upload"
    # Dir.mkdir(directory) unless File.exists?(directory)
    # path = File.join(directory, name)
    # File.open(path, "wb") { |f| f.write(file.read) }

    # TODO: Save file to box.net
    # TODO: Check user permission with documentable first
    @document = Document.new(document_params.merge(:file_name => name, :file_size => file.size, :file_type => File.extname(name).try(:gsub, /^\./, "")))
    @document.created_by = current_user.organization_user.id
    if @document.save
      @document.create_signers!(params["document"]["signers"].values) if params["document"]["signers"]
      @document.upload_file(file, current_user.organization_user)
      success_response(["Document created successfully."])
    else
      error_response(@document.errors)
    end
  end

  def update
    file = params[:document][:file]

    # TODO: Save file to box.net
    # TODO: Check user permission with documentable first
    # TODO: For now update will add/duplicate documentable
    attrs = document_params
    if file.present?
      name = file.original_filename
      attrs = attrs.merge(:file_name => name, :file_size => file.size, :file_type => File.extname(name).try(:gsub, /^\./, ""))
    end

    if @document.update(attrs)
      @document.document_signers.destroy_all
      @document.create_signers!(params["document"]["signers"].values) if params["document"]["signers"]
      @document.upload_file(file, @document.creator)
      success_response(["Document updated successfully"])
    else
      error_response(@document.errors)
    end
  end

  def show
    success_response(
      {
        document: @document.to_hash.merge(:type => @document.class.name, :id => @document.id, :can_update => can?(:update, @document.deal))
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

  def create_version
    if version_params[:file].present? && version_params[:file].kind_of?(ActionDispatch::Http::UploadedFile)
      file_name = version_params[:file].original_filename
      name = version_params[:name] || File.basename(file_name)

      @document.upload_file(version_params[:file], current_user.organization_user)

      success_response({
        document: @document.to_hash
      })
    else
      error_response(["Bad request"])
    end
  end

  def send_to_docusign
    @document.send_to_docusign

    render json: {}, status: :ok
  end

  private
  def set_document
    @document = Document.find_by_id(params[:id])
    error_response(["Document Not Found"]) if @document.blank?
  end

  def document_params
    params.require(:document).permit(
      :title,
      :deal_id,
      :deal_documents_attributes => [:id, :documentable_id, :documentable_type]
    )
  end

  def version_params
    params.require(:version).permit(:name, :file)
  end

  protected
  def ensure_params_exist
    if params[:document].blank?
      error_response(["Document related parameters not found."])
    end
  end
end
