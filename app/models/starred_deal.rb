class StarredDeal < ActiveRecord::Base
  # Associations
  belongs_to :deal
  belongs_to :organization_user
  
  # Validations
  validates(
    :deal_id,
    presence: true,
    uniqueness:{
      scope: :organization_user_id
    }
  )
  validates(
    :organization_user_id,
    presence: true
  )

  def to_hash
    return self.deal.to_hash
  end
end
