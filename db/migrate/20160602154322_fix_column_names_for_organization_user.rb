class FixColumnNamesForOrganizationUser < ActiveRecord::Migration[5.0]
  def change
  	rename_column :comments, :user_id, :organization_user_id
  	rename_column :document_signers, :user_id, :organization_user_id
  	rename_column :notifications, :user_id, :organization_user_id
  	rename_column :starred_deals, :user_id, :organization_user_id
  end
end
