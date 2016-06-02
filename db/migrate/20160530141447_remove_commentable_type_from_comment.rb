class RemoveCommentableTypeFromComment < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :commentable_type, :integer
  end
end
