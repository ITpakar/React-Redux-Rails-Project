class DocumentSignersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :authenticate_document_owner!, only: [:create, :update, :destroy]
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_document
  before_action :set_document_signer, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    @document_signers = @document.document_signers
                                 .order("#{sortby} #{sortdir}")
                                 .page(@page)
                                 .per(@per_page) rescue []
    success_response(
      {
        document_signers: @document_signers.map(&:to_hash)
      }
    )
  end

  def show
    success_response(
      {
        document_signer: @document_signer.to_hash
      }
    )
  end

  def create
    @document_signer = @document.document_signers.new(document_signer_params)
    if @document_signer.save
      success_response(["Document Signer created successfully."])
    else
      error_response(@document_signer.errors)
    end
  end

  def update
    if @document_signer.update(document_signer_params)
      success_response(["Document Signer updated successfully"])
    else
      error_response(@document_signer.errors)
    end
  end

  def destroy
    if @document_signer.destroy
      success_response(["Document Signer destroyed successfully"])
    else
      error_response(@document_signer.errors)
    end
  end

  private
  def set_document
    @document = Document.find_by_id(params[:document_id])
    error_response(["Document Not Found"]) if @document.blank?
  end

  def set_document_signer
    @document_signer = @document.document_signers.find_by_id(params[:id])
    error_response(["Document Signer Not Found"]) if @document_signer.blank?
  end

  def document_signer_params
    params.require(:document_signer).permit(
      :document_id,
      :user_id,
      :signed,
      :signed_at
    )
  end

  protected
  def ensure_params_exist
    if params[:document_signer].blank?
      error_response(["Document Signer related parameters not found."])
    end
  end
end
