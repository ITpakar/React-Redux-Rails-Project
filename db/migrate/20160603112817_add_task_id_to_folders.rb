class AddTaskIdToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :task_id, :integer
  end
end
