class Deal < ActiveRecord::Base
  # Validations
  validates(
    :title,
    length:{
      maximum: 250
    }
  )

  # Associations
  belongs_to :organization
  has_many   :starred_deals
  has_many   :deal_collaborators
  has_many   :users, through: :deal_collaborators
  has_many   :sections
end
