class RemoveDealSizeToDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :deal_size, :string
  end
end
