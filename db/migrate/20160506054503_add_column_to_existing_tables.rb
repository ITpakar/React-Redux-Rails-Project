class AddColumnToExistingTables < ActiveRecord::Migration[5.0]
  def change
    add_column :users,              :activated,           :boolean
    add_column :users,              :role,                :string
    add_column :organization_users, :invitation_accepted, :boolean
    add_column :organization_users, :invitation_token,    :string
    
    
    add_index  :users, :activated
    add_index  :users, :role
    add_index  :organization_users, :invitation_accepted
  end
end



