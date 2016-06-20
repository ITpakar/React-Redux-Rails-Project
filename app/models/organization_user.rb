class OrganizationUser < ActiveRecord::Base
  include DealOwner
  include BoxStorable

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
  has_many :folders, :foreign_key => :created_by
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

  def is_deal_collaborator? deal
    return true if self.user.is_super?

    deal_collaborator = DealCollaborator.where(
      organization_user_id: id,
      deal_id: deal.deal_id
    ).first

    return !deal_collaborator.blank?
  end

  def to_s
    self.user.email
  end

  def to_hash
    return self.attributes
  end

  # Metaprogramming for the to find the correct STI classes
  class << self
    def find_sti_class(type_name)
      self
    end
  end
end
