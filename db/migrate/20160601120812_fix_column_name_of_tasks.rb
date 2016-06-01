class FixColumnNameOfTasks < ActiveRecord::Migration[5.0]
  def change
  	rename_column :tasks, :organization_id, :organization_user_id
  end
end
