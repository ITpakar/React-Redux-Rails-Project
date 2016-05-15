class Task < ActiveRecord::Base
  # Validations
  validates(
    :title,
    length:{
      maximum: 250
    }
  )
  validates(
    :section_id,
    presence: true
  )
  validates(
    :organization_id,
    presence: true
  )
  validates(
    :deal_id,
    presence: true
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
  belongs_to :section
  belongs_to :organization
  belongs_to :deal
  belongs_to :creator, foreign_key: :created_by, class_name: 'User'
  belongs_to :assingnee, foreign_key: :assignee_id, class_name: 'User'

  def to_hash
    data = {
      task_id:      self.id,
      title:        self.title,
      description:  self.description,
      status:       self.status,
      section_id:   self.section_id,
      due_date:     self.due_date
    }

    if self.creator
      data[:creator] = self.creator.to_hash(false)
    end

    if self.assingnee
      data[:assingnee] = self.assingnee.to_hash(false)
    end

    return data
  end
end
