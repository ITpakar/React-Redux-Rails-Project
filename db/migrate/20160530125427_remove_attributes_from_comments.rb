class RemoveAttributesFromComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :task_id, :integer
    remove_column :comments, :document_id, :integer
    remove_column :comments, :deal_id, :integer
  end
end
