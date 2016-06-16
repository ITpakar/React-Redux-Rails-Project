class AddDownloadUrlToDealDocumentVersions < ActiveRecord::Migration[5.0]
  def change
  	add_column :deal_document_versions, :download_url, :varchar
  end
end
