class User < ActiveRecord::Base
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable
  )

  # Validations
  validates(
    :email,
    presence: true
  )
  validates(
    :phone,
    allow_blank: true,
    length:{
      maximum: 15
    }
  )
  validates(
    :company,
    allow_blank: true,
    length:{
      maximum: 100
    }
  )

  #Associations
  has_one  :organization_user, dependent: :destroy
  has_one  :organization,      through: :organization_user
  has_many :document_signers
  has_many :documents, through: :document_signers
  has_many :comments
  has_many :deal_collaborators
  has_many :deals, through: :deal_collaborators
  has_many :notifications
  has_many :starred_deals
  has_many :tasks
  has_many :folders, foreign_key: :created_by

  def create_organization
    Organization.create(
      name: self.company,
      phone: self.phone,
      address: self.address,
      created_by: self.id,
      activated: true
    )
  end

  def create_organization_user(organization_id)
    OrganizationUser.create(
      user_id: self.id,
      organization_id: organization_id,
      user_type: 'Admin'
    )
  end

  def is_organzation_admin?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationUser.where(
      user_id: id,
      organization_id: organization_id,
      user_type: ORG_USER_TYPE_ADMIN
    ).first
    return !organization_user.blank?
  end

  def is_organzation_member?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationUser.where(
      user_id: id,
      organization_id: organization_id
    ).first
    return !organization_user.blank?
  end

  def is_org_deal_admin?(deal_id)
    return true if self.is_super?

    deal = self.deals.find_by_id(deal_id)
    return if deal.admin_user_id == self.id or deal.organization.creator.id == self.id
  end

  def is_deal_collaborator?(deal_id)
    return true if self.is_super?

    deal_collaborator = DealCollaborator.where(
      user_id: id,
      deal_id: deal_id
    ).first
    return !deal_collaborator.blank?
  end

  def is_super?
    self.role == USER_SUPER
  end

  def to_hash(add_organization = true)
    data = {
      email: self.email,
      user_id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      phone: self.phone,
      address: self.address,
      company: self.company,
      activated: self.activated,
      role: self.role
    }

    if add_organization and self.organization
      data[:organization] = [
        {
          id: self.organization.id,
          name: self.organization.name
        }
      ]
    end

    return data
  end
end
