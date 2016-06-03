class AddVisibilityFieldToRelatedModels < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections, :visibility, :integer, default: 0
  	add_column :folders, :visibility, :integer, default: 0
  	add_column :tasks, :visibility, :integer, default: 0
  	add_column :documents, :visibility, :integer, default: 0
  end
end
