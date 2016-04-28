class StarredDealsController < ApplicationController
  before_action :set_starred_deal, only: [:show, :edit, :update, :destroy]

  # GET /starred_deals
  # GET /starred_deals.json
  def index
    @starred_deals = StarredDeal.all
  end

  # GET /starred_deals/1
  # GET /starred_deals/1.json
  def show
  end

  # GET /starred_deals/new
  def new
    @starred_deal = StarredDeal.new
  end

  # GET /starred_deals/1/edit
  def edit
  end

  # POST /starred_deals
  # POST /starred_deals.json
  def create
    @starred_deal = StarredDeal.new(starred_deal_params)

    respond_to do |format|
      if @starred_deal.save
        format.html { redirect_to @starred_deal, notice: 'Starred deal was successfully created.' }
        format.json { render :show, status: :created, location: @starred_deal }
      else
        format.html { render :new }
        format.json { render json: @starred_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /starred_deals/1
  # PATCH/PUT /starred_deals/1.json
  def update
    respond_to do |format|
      if @starred_deal.update(starred_deal_params)
        format.html { redirect_to @starred_deal, notice: 'Starred deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @starred_deal }
      else
        format.html { render :edit }
        format.json { render json: @starred_deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /starred_deals/1
  # DELETE /starred_deals/1.json
  def destroy
    @starred_deal.destroy
    respond_to do |format|
      format.html { redirect_to starred_deals_url, notice: 'Starred deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_starred_deal
      @starred_deal = StarredDeal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def starred_deal_params
      params.require(:starred_deal).permit(:user_id, :deal_id)
    end
end
