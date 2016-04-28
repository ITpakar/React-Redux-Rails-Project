class DocumentSignersController < ApplicationController
  before_action :set_document_signer, only: [:show, :edit, :update, :destroy]

  # GET /document_signers
  # GET /document_signers.json
  def index
    @document_signers = DocumentSigner.all
  end

  # GET /document_signers/1
  # GET /document_signers/1.json
  def show
  end

  # GET /document_signers/new
  def new
    @document_signer = DocumentSigner.new
  end

  # GET /document_signers/1/edit
  def edit
  end

  # POST /document_signers
  # POST /document_signers.json
  def create
    @document_signer = DocumentSigner.new(document_signer_params)

    respond_to do |format|
      if @document_signer.save
        format.html { redirect_to @document_signer, notice: 'Document signer was successfully created.' }
        format.json { render :show, status: :created, location: @document_signer }
      else
        format.html { render :new }
        format.json { render json: @document_signer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /document_signers/1
  # PATCH/PUT /document_signers/1.json
  def update
    respond_to do |format|
      if @document_signer.update(document_signer_params)
        format.html { redirect_to @document_signer, notice: 'Document signer was successfully updated.' }
        format.json { render :show, status: :ok, location: @document_signer }
      else
        format.html { render :edit }
        format.json { render json: @document_signer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /document_signers/1
  # DELETE /document_signers/1.json
  def destroy
    @document_signer.destroy
    respond_to do |format|
      format.html { redirect_to document_signers_url, notice: 'Document signer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document_signer
      @document_signer = DocumentSigner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_signer_params
      params.require(:document_signer).permit(:document_id, :user_id, :signed, :signed_at)
    end
end
