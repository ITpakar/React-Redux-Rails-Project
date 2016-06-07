class CreateDealCollaboratorInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_collaborator_invites do |t|
      t.integer  :deal_id
      t.integer  :email
      t.integer  :added_by
      t.string   :token

      t.timestamps null: false
    end

    add_index :deal_collaborator_invites, :deal_id
    add_index :deal_collaborator_invites, :added_by
    add_index :deal_collaborator_invites, :token, unique: true
    add_index :deal_collaborator_invites, [:deal_id, :email], unique: true
  end
end
