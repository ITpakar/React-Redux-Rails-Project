class AddUrlToDealDocuments < ActiveRecord::Migration[5.0]
  def change
  	add_column :deal_documents, :url, :varchar
  end
end
