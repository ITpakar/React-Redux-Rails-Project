class AddTypeToDealCollaborators < ActiveRecord::Migration[5.0]
  def change
    add_column :deal_collaborators, :type, :string
  end
end
