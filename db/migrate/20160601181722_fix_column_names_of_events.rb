class FixColumnNamesOfEvents < ActiveRecord::Migration[5.0]
  def change
  	rename_column :events, :subject_id,   :trigger_id
  	rename_column :events, :subject_type, :trigger_type
  end
end
