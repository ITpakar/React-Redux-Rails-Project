class RemoveTriggerFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :trigger_id, :integer
    remove_column :events, :trigger_type, :string
  end
end
