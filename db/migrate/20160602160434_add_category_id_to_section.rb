class AddCategoryIdToSection < ActiveRecord::Migration[5.0]
  def change
    add_column :sections, :category_id, :integer
  end
end
