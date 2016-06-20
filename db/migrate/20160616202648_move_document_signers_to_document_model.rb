class MoveDocumentSignersToDocumentModel < ActiveRecord::Migration[5.0]
  def change
    rename_column :document_signers, :deal_document_id, :document_id
  end
end
