class AddUrlToDealDocumentVersions < ActiveRecord::Migration[5.0]
  def change
  	add_column :deal_document_versions, :url, :varchar
  end
end
