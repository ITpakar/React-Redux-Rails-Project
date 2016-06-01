class AddPolymorphismToComments < ActiveRecord::Migration[5.0]
  def change
  	add_column :comments, :commentable_id, :integer, index: true
  	add_column :comments, :commentable_type, :string
  end
end
