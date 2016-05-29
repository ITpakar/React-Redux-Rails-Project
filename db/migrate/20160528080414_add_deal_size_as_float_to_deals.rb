class AddDealSizeAsFloatToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :deal_size, :float
  end
end
