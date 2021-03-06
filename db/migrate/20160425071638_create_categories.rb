class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string   :name, limit: 100
      t.boolean  :activated
      t.integer  :parent_id

      t.timestamps null: false
    end
  end
end
