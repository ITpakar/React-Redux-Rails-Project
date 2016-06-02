class RemoveParentIdFromCategories < ActiveRecord::Migration[5.0]
  def change
    remove_column :categories, :parent_id, :integer
  end
end
