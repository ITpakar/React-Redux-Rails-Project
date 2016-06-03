class Task < ApplicationRecord
  include Traversable
  
  STATUSES = ["Complete", "Incomplete"]

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
    :organization_user_id,
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
  belongs_to :section
  belongs_to :organization_user
  belongs_to :assignee, foreign_key: :assignee_id, class_name: 'OrganizationUser', optional: true

  has_many :comments, as: :commentable
  has_many :folders, as: :parent
  has_many :deal_documents, as: :documentable
  has_many :documents, through: :deal_documents

  scope :diligence, -> {where(category_id: Category.diligence.id)}
  scope :closing, -> {where(category_id: Category.closing.id)}
  scope :complete, -> {where(status: "Complete")}
  scope :incomplete, -> {where(status: "Incomplete")}

  before_validation :set_category_id, unless: :category_id
  after_create :create_notification_if_complete

  def create_notification_if_complete
    if self.status_was != self.status and self.status == "Complete"
      Event.create(deal_id: self.deal_id, action: "TASK_COMPLETED", trigger: self)
    end
  end

  def set_category_id
    self.category_id = self.section.category_id
  end

  def complete!
    self.status = "Complete"
    save
  end

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

    if self.assignee
      data[:assignee] = self.assignee.to_hash(false)
    end

    return data
  end
end
