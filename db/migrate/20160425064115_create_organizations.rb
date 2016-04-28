class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string   :name, limit: 250
      t.string   :email_domain
      t.string   :phone
      t.string   :address
      t.integer  :created_by
      t.boolean  :activated

      t.timestamps null: false
    end
    add_index :organizations, :name, unique: true
    add_index :organizations, :created_by
    add_index :organizations, :activated
  end
end
