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
  has_many   :deal_collaborators, dependent: :delete_all
  has_many   :users, through: :deal_collaborators
  has_many   :sections
  belongs_to :creator, foreign_key: :admin_user_id, class_name: 'User'

  def to_hash
    data = {
      deal_id:              self.id,
      title:                self.title,
      client_name:          self.client_name,
      transaction_type:     self.transaction_type,
      deal_size:            self.deal_size,
      projected_close_date: self.projected_close_date,
      completion_percent:   self.completion_percent,
      status:               self.status,
      activated:            self.activated
    }
    if self.creator
      data[:admin] = self.creator.to_hash(false)
    end

    return data
  end
end
