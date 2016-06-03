class RemovePolymorphismFromDocuments < ActiveRecord::Migration[5.0]
  def change
  	remove_column :documents, :documentable_id
  	remove_column :documents, :documentable_type
  end
end
