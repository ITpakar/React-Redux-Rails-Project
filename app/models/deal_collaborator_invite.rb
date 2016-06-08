class DealCollaboratorInvite < ActiveRecord::Base
  has_secure_token :token
  # Associations
  belongs_to :deal
  belongs_to :addor, foreign_key: :added_by, class_name: 'OrganizationUser'
end
