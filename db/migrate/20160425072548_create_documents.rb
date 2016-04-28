class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string   :file_name
      t.integer  :file_size
      t.string   :file_type
      t.datetime :file_uploaded_at
      t.string   :parent_type
      t.integer  :parent_id
      t.integer  :created_by
      t.boolean  :activated

      t.timestamps null: false
    end
    add_index :documents, :parent_type
    add_index :documents, :parent_id
    add_index :documents, :created_by
  end
end
