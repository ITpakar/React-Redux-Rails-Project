class AddRecordTypeToOrganizationUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :organization_users, :record_type, :string, :limit => 255
  end
end
