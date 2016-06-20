class RemoveAvatarFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :avatar_name
  	remove_column :users, :avatar_size
  	remove_column :users, :avatar_type
  end
end
