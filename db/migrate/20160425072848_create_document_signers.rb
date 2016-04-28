class CreateDocumentSigners < ActiveRecord::Migration[5.0]
  def change
    create_table :document_signers do |t|
      t.integer  :document_id
      t.integer  :user_id
      t.boolean  :signed
      t.datetime :signed_at

      t.timestamps null: false
    end
  end
end
