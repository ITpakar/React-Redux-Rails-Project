class ClosingBookDocument < ApplicationRecord
  belongs_to :document
  belongs_to :closing_book
end
