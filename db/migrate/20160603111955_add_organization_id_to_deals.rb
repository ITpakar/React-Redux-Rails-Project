class AddOrganizationIdToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :organization_id, :integer
  end
end
