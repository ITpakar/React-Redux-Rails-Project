class AddDealIdToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :deal_id, :integer
  end
end
