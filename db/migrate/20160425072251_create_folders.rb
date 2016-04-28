class CreateFolders < ActiveRecord::Migration[5.0]
  def change
    create_table :folders do |t|
      t.string :name, limit: 250
      t.string :parent_type
      t.integer :parent_id
      t.integer :created_by
      t.boolean :activated

      t.timestamps null: false
    end
    add_index :folders, :parent_type
    add_index :folders, :parent_id
    add_index :folders, :created_by
  end
end
