class SectionsController < ApplicationController
  respond_to :json

  before_action :authentication_deal_collaborator!
  before_action :ensure_params_exist, only: [:create, :update]
  before_action :set_deal
  before_action :set_section, only: [:show, :update, :destroy]
  skip_before_action :verify_authenticity_token

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

  def create
    @section = @deal.sections.new(section_params)
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
