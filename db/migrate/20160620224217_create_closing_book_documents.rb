class CreateClosingBookDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :closing_book_documents do |t|
      t.integer :document_id
      t.integer :closing_book_id

      t.timestamps
    end
  end
end
