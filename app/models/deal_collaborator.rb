class DealCollaborator < ActiveRecord::Base
  # Associations
  belongs_to :deal
  belongs_to :user
end
