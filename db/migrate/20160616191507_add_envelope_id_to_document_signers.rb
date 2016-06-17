class AddEnvelopeIdToDocumentSigners < ActiveRecord::Migration[5.0]
  def change
    add_column :document_signers, :envelope_id, :string
  end
end
