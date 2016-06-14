class MoveBoxUserIdToOrganizationUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :box_user_id, :varchar
  	add_column :organization_users, :box_user_id, :varchar
  end
end
