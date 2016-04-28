class CreateStarredDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :starred_deals do |t|
      t.integer  :user_id
      t.integer  :deal_id

      t.timestamps null: false
    end
  end
end
