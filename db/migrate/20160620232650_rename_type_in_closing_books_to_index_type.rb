class RenameTypeInClosingBooksToIndexType < ActiveRecord::Migration[5.0]
  def change
    rename_column :closing_books, :type, :index_type
  end
end
