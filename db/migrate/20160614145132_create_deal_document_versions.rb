class CreateDealDocumentVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_document_versions do |t|
    	t.integer  :deal_document_id
    	t.string   :name
    	t.string   :box_version_id

    	t.timestamps null: false
    end

    add_index :deal_document_versions, :deal_document_id
  end
end
