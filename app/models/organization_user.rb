class OrganizationUser < ActiveRecord::Base
  include DealOwner

  TYPES = ["Internal", "External"]

  # Associations
  belongs_to :user
  belongs_to :organization

  has_many :document_signers
  has_many :documents, through: :document_signers
  has_many :comments
  has_many :notifications
  has_many :starred_deals
  has_many :tasks
  has_many :folders
  has_many :sections
  has_many :deal_collaborators
  has_many :deals, through: :deal_collaborators

  before_validation :set_type

  def set_type
    if organization.email_domain == user.email_domain
      self.type = "Internal"
    else
      self.type = "External"
    end
  end

  # We implement this because it's required by DealOwner
  def email_domain
    self.organization.email_domain
  end

  def star! deal
    StarredDeal.create(organization_user_id: self.id, deal_id: deal.id)
  end

  # Metaprogramming for the to find the correct STI classes
  class << self
    def find_sti_class(type_name)
      self
    end
  end
end
