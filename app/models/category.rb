class Category < ActiveRecord::Base
  # Validations
  validates(
    :name,
    length:{
      maximum: 100
    }
  )

  scope :diligence, -> {where(name: 'Diligence').first}
  scope :closing, -> {where(name: 'Closing').first}
  # Associations
  has_many :sections
end
