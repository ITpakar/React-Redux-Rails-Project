class AddOrganizationIdToDeal < ActiveRecord::Migration[5.0]
  def change
  	add_column :deals, :organization_id, :integer, index: true
  end
end
