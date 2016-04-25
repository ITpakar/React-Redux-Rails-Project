class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.integer  :organization_id
      t.string   :title, limit: 250
      t.string   :client_name
      t.string   :transaction_type
      t.string   :deal_size
      t.date     :projected_closing_date
      t.float    :completion_percent
      t.string   :status
      t.integer  :admin_user_id
      t.boolean  :activated

      t.timestamps null: false
    end
    add_index :deals, :title
    add_index :deals, :status
    add_index :deals, :admin_user_id
    add_index :deals, :activated
  end
end
