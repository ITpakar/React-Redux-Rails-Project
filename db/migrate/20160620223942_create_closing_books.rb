class CreateClosingBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :closing_books do |t|
      t.integer :deal_id
      t.string :status
      t.string :url

      t.timestamps
    end
  end
end
