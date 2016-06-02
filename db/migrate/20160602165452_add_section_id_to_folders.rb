class AddSectionIdToFolders < ActiveRecord::Migration[5.0]
  def change
    add_column :folders, :section_id, :integer
  end
end
