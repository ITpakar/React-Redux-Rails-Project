class RemoveSectionIdFromFolders < ActiveRecord::Migration[5.0]
  def change
    remove_column :folders, :section_id, :integer
  end
end
