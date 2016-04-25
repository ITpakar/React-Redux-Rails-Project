class Organization < ActiveRecord::Base
  # Validations
  validates(
    :name,
    length:{
      maximum: 250
    }
  )

  # Associations
  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :deals
end
