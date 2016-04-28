class Section < ActiveRecord::Base
  # Associations
  belongs_to :deal
  belongs_to :category
  has_many   :tasks
end
