class RecreateDocumentSigners < ActiveRecord::Migration[5.0]
  def change
      create_table :document_signers do |t|
        t.string   :email
        t.string   :name
        t.integer  :deal_document_id
        t.boolean  :signed, default: false

        t.timestamps null: false
    end
  end
end
