class RemoveDocumentSigners < ActiveRecord::Migration[5.0]
  def change
    drop_table :document_signers
  end
end
