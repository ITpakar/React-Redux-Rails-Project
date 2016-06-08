class AddBoxUserIdToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :box_user_id, :integer
  end
end
