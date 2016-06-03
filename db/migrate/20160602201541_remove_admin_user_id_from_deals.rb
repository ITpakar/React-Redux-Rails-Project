class RemoveAdminUserIdFromDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :admin_user_id, :integer
  end
end
