class CreateDealCollaboratorInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :deal_collaborator_invites do |t|
      t.integer  :deal_id
      t.integer  :organization_user_id
      t.integer  :added_by
      t.string   :type

      t.timestamps null: false
    end

    add_index :deal_collaborator_invites, :deal_id
    add_index :deal_collaborator_invites, :organization_user_id
    add_index :deal_collaborator_invites, :added_by
  end
end
