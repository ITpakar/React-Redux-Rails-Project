class RenameUserIdColumnOfDealCollaborators < ActiveRecord::Migration[5.0]
  def change
  	rename_column :deal_collaborators, :user_id, :organization_user_id
  end
end
