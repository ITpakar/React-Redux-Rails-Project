class RemoveBoxFromDealDocuments < ActiveRecord::Migration[5.0]
  def change
  	remove_column :deal_documents, :box_file_id
  	remove_column :deal_documents, :url
  	remove_column :deal_documents, :download_url
  end
end
