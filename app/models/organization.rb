class Organization < ActiveRecord::Base
  include DealOwner
  # Validations
  validates(
    :name,
    presence: true,
    uniqueness: true,
    length:{
      maximum: 250
    }
  )

  # Associations
  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :deals, dependent: :delete_all
  belongs_to :creator, foreign_key: :created_by, class_name: 'User'

  after_create :create_organization_user

  def create_organization_user
    OrganizationInternalUser.create(
      user_id: creator.id, 
      organization_id: self.id,
      type: "Internal")
  end

  def to_hash
    data = {
      name: self.name,
      email_domain: self.email_domain,
      phone: self.phone,
      address: self.address,
      activated: self.activated
    }
    if self.creator
      data[:admin] = self.creator.to_hash(false)
    end

    return data
  end
end
