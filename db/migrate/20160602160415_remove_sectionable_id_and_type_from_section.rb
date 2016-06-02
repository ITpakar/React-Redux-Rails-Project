class RemoveSectionableIdAndTypeFromSection < ActiveRecord::Migration[5.0]
  def change
    remove_column :sections, :sectionable_type, :string
    remove_column :sections, :sectionable_id, :integer
  end
end
