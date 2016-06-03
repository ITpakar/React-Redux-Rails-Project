class RemoveUnnecessaryColumnsFromDeals < ActiveRecord::Migration[5.0]
  def change
  	remove_column :deals, :organization_id
  end
end
