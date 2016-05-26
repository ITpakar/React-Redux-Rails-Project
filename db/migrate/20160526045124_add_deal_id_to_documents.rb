class AddDealIdToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :deal_id, :integer
  end
end
