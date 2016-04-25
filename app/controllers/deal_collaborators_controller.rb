class DealCollaboratorsController < ApplicationController
  before_action :set_deal_collaborator, only: [:show, :edit, :update, :destroy]

  # GET /deal_collaborators
  # GET /deal_collaborators.json
  def index
    @deal_collaborators = DealCollaborator.all
  end

  # GET /deal_collaborators/1
  # GET /deal_collaborators/1.json
  def show
  end

  # GET /deal_collaborators/new
  def new
    @deal_collaborator = DealCollaborator.new
  end

  # GET /deal_collaborators/1/edit
  def edit
  end

  # POST /deal_collaborators
  # POST /deal_collaborators.json
  def create
    @deal_collaborator = DealCollaborator.new(deal_collaborator_params)

    respond_to do |format|
      if @deal_collaborator.save
        format.html { redirect_to @deal_collaborator, notice: 'Deal collaborator was successfully created.' }
        format.json { render :show, status: :created, location: @deal_collaborator }
      else
        format.html { render :new }
        format.json { render json: @deal_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_collaborators/1
  # PATCH/PUT /deal_collaborators/1.json
  def update
    respond_to do |format|
      if @deal_collaborator.update(deal_collaborator_params)
        format.html { redirect_to @deal_collaborator, notice: 'Deal collaborator was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_collaborator }
      else
        format.html { render :edit }
        format.json { render json: @deal_collaborator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_collaborators/1
  # DELETE /deal_collaborators/1.json
  def destroy
    @deal_collaborator.destroy
    respond_to do |format|
      format.html { redirect_to deal_collaborators_url, notice: 'Deal collaborator was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal_collaborator
      @deal_collaborator = DealCollaborator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_collaborator_params
      params.require(:deal_collaborator).permit(:deal_id, :user_id, :added_by)
    end
end
