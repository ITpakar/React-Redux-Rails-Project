class AddBoxFileIdToDealDocuments < ActiveRecord::Migration[5.0]
  def change
  	add_column :deal_documents, :box_file_id, :varchar
  end
end
