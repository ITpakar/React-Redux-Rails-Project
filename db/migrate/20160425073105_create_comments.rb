class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer  :user_id
      t.integer  :task_id
      t.integer  :document_id
      t.string   :comment_type
      t.text     :comment

      t.timestamps null: false
    end
    add_index :comments, :user_id
  end
end
