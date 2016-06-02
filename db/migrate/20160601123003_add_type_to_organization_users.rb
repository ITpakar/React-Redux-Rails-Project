class AddTypeToOrganizationUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :organization_users, :type, :string
  end
end
