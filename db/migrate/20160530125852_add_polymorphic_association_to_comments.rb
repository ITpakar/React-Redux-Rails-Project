class AddPolymorphicAssociationToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :integer
  end
end
