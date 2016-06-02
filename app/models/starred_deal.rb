class StarredDeal < ActiveRecord::Base
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
  # Associations
  belongs_to :deal
  belongs_to :organization_user

  def to_hash
    return self.deal.to_hash
  end
end
