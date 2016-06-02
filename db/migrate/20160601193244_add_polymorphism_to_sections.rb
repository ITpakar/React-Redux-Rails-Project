class AddPolymorphismToSections < ActiveRecord::Migration[5.0]
  def change
  	add_column :sections, :sectionable_id, :integer, index: true
  	add_column :sections, :sectionable_type, :string
  end
end
