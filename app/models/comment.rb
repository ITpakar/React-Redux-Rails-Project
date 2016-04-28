class Comment < ActiveRecord::Base
  # Associations
  belongs_to :user
  belongs_to :task, required: false
  belongs_to :document, required: false
end
