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
  belongs_to :creator, foreign_key: :created_by, class_name: 'User'

  def to_hash
    data = {
      name: self.name,
      email_domain: self.email_domain,
      phone: self.phone,
      address: self.address
    }
    if self.creator
      data[:admin] = self.creator.to_hash(false)
    end

    return data
  end
end
