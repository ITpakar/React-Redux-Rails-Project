class AddDownloadUrlToDealDocuments < ActiveRecord::Migration[5.0]
  def change
  	add_column :deal_documents, :download_url, :varchar
  end
end
