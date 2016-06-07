class DealCollaboratorInvite < ActiveRecord::Base
  has_secure_token :token
  # Associations
  belongs_to :deal
end
