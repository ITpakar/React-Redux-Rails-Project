class AddDealIdToCategories < ActiveRecord::Migration[5.0]
  def change
  	add_column :categories, :deal_id, :integer
  end
end
