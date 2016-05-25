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
  has_many   :starred_deals, dependent: :delete_all
  has_many   :deal_collaborators, dependent: :delete_all
  has_many   :users, through: :deal_collaborators
  has_many   :sections, dependent: :delete_all
  has_many   :tasks, dependent: :delete_all
  belongs_to :creator, foreign_key: :admin_user_id, class_name: 'User'

  after_create :set_default_status
  after_create :create_deal_collaborator

  def set_default_status
    unless status
      status = "Unstarted"
      save
    end
  end

  def create_deal_collaborator
    self.deal_collaborators.create(
      user_id: self.admin_user_id,
      added_by: self.admin_user_id
    )
  end

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
