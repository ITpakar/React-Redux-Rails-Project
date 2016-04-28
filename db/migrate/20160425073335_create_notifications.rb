class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.integer  :user_id
      t.text     :message
      t.string   :status

      t.timestamps null: false
    end
  end
end
