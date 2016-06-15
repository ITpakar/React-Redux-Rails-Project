class CreateKpis < ActiveRecord::Migration[5.0]
  def change
    create_table :kpis do |t|
      t.integer :organization_id
      t.string :key
      t.integer :value

      t.timestamps
    end
  end
end
