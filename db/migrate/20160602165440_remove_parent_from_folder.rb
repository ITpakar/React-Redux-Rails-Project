class RemoveParentFromFolder < ActiveRecord::Migration[5.0]
  def change
    remove_column :folders, :parent_id, :integer
    remove_column :folders, :parent_type, :string
  end
end
