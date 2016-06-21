class DealCollaborator < ActiveRecord::Base
  self.inheritance_column = nil

  # Associations
  belongs_to :deal
  belongs_to :organization_user, :foreign_key => :organization_user_id
  belongs_to :addor, foreign_key: :added_by, class_name: 'OrganizationUser'

  before_save :set_type

  def set_type
    self.type ||= self.organization_user.type
  end

  def to_hash
    return self.organization_user.user.to_hash(false)
  end
end
