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
    organization_user = OrganizationUser.where(user_id: id, organization_id: organization_id, user_type: ORG_USER_TYPE_ADMIN).first
    return !organization_user.blank?
  end

  def to_hash(add_organization = true)
    data = {
      email: self.email,
      user_id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      phone: self.phone,
      address: self.address,
      company: self.company
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
