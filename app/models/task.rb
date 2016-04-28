class Task < ActiveRecord::Base
  # Validations
  validates(
    :title,
    length:{
      maximum: 250
    }
  )
  validates(
    :description,
    length:{
      maximum: 1000
    }
  )
  validates(
    :status,
    length:{
      maximum: 30
    }
  )

  # Associations
  has_many :comments
  belongs_to :user, foreign_key: 'assingnee_id'
  belongs_to :section
end
