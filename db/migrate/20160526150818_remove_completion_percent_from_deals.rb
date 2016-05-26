class RemoveCompletionPercentFromDeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :deals, :completion_percent, :float
  end
end
