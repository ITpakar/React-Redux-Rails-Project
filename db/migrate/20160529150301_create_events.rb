class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :deal_id
      t.string :type
      t.string :subject_type
      t.integer :subject_id

      t.timestamps
    end
  end
end
