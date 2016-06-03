class DealCollaborator < ActiveRecord::Base
  # Associations
  belongs_to :deal
  belongs_to :organization_user

  def to_hash
    return self.organization_user.user.to_hash(false)
  end
end
