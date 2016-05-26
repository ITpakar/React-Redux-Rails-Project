class AddDealIdToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :deal_id, :integer
  end
end
