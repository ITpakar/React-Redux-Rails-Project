class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string   :name, limit: 100
      t.integer  :deal_id
      t.integer  :category_id
      t.integer  :created_by
      t.boolean  :activated

      t.timestamps null: false
    end
    add_index :sections, :created_by
    add_index :sections, :activated
  end
end
