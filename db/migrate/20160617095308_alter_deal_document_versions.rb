class AlterDealDocumentVersions < ActiveRecord::Migration[5.0]
  def change
  	rename_column :deal_document_versions, :box_version_id, :box_file_id
  end
end
