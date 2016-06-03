class RemoveUserTypeColumnOfOrganizationUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :organization_users, :user_type
  end
end
