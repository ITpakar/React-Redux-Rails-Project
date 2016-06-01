class RemoveUnnecessaryColumnsFromComments < ActiveRecord::Migration[5.0]
  def change
  	remove_column :comments, :task_id
  	remove_column :comments, :document_id
  end
end
