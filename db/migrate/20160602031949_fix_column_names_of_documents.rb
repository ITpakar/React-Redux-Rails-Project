class FixColumnNamesOfDocuments < ActiveRecord::Migration[5.0]
  def change
  	rename_column :documents, :parent_id,   :documentable_id
  	rename_column :documents, :parent_type, :documentable_type
  end
end
