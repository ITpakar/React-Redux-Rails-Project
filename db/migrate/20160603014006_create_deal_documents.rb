class CreateDealDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_documents do |t|
      t.integer :document_id
      t.integer :documentable_id
      t.string  :documentable_type
      t.timestamps
    end
    add_index :deal_documents, :document_id
    add_index :deal_documents, :documentable_id
  end
end
