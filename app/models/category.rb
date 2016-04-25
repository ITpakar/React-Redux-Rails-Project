class Category < ActiveRecord::Base
  # Validations
  validates(
    :name,
    length:{
      maximum: 100
    }
  )

  # Associations
  has_many :sections
end
