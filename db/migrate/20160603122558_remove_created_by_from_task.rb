class RemoveCreatedByFromTask < ActiveRecord::Migration[5.0]
  def change
    remove_column :tasks, :created_by, :integer
  end
end
