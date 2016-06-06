class AddDealIdToDealDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :deal_documents, :deal_id, :integer
  end
end
