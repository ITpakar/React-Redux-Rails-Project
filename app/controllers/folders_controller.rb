class FoldersController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  def index
    sortby  = params[:sortby] || ''
    sortdir = params[:sortdir] || ''
    @folders = current_user.folders
                           .order("#{sortby} #{sortdir}")
                           .page(@page)
                           .per(@per_page) rescue []
    success_response(
      {
        sections: @folders.map(&:to_hash)
      }
    )
  end

  def create
    @folder = current_user.folders.new(folderl_params)
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
    if @folder
      success_response(
        {
          folder: @folder.to_hash
        }
      )
    end
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
    @folder = Folder.find(params[:id])
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
end
