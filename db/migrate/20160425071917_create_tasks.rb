class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string   :title,       limit: 250
      t.string   :description, limit: 1000
      t.string   :status,      limit: 30
      t.integer  :section_id
      t.integer  :assingnee_id
      t.integer  :created_by
      t.datetime :due_date

      t.timestamps null: false
    end
    add_index :tasks, :status
    add_index :tasks, :section_id
    add_index :tasks, :assingnee_id
    add_index :tasks, :created_by
  end
end
