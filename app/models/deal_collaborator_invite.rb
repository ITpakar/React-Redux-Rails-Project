class DealCollaboratorInvite < ActiveRecord::Base
  has_secure_token :token
  # Associations
  belongs_to :deal
  belongs_to :addor, foreign_key: :added_by, class_name: 'OrganizationUser'

  after_create :create_event

  def to_hash
    data = {
      id: self.email,
      email: self.email,
      user_id: self.email,
      first_name: self.email,
      name: self.email,
    }

    return data
  end

  def create_event
    Event.create(deal_id: self.deal_id, action: "COLLABORATOR_INVITED", eventable: self)
  end
end
