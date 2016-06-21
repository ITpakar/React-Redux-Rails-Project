class AddTypeToClosingBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :closing_books, :type, :string
  end
end
