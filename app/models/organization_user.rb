class OrganizationUser < ActiveRecord::Base
  include DealOwner

  # Associations
  belongs_to :user
  belongs_to :organization

  has_many :document_signers
  has_many :documents, through: :document_signers
  has_many :comments
  has_many :deals
  has_many :notifications
  has_many :starred_deals
  has_many :tasks
  has_many :folders
  has_many :sections
  has_many :deals, through: :deal_collaborators
  has_many :collaborators, :as => :collaboratable

  # We implement this because it's required by DealOwner
  def email_domain
    self.organization.email_domain
  end
end
