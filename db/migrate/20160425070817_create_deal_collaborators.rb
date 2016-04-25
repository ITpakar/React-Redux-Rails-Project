class CreateDealCollaborators < ActiveRecord::Migration
  def change
    create_table :deal_collaborators do |t|
      t.integer  :deal_id
      t.integer  :user_id
      t.integer  :added_by

      t.timestamps null: false
    end
    add_index :deal_collaborators, :deal_id
    add_index :deal_collaborators, :user_id
    add_index :deal_collaborators, :added_by
  end
end
