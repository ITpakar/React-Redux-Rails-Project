class Task < ApplicationRecord
  
  include HasVisibility
  
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
  belongs_to :deal
  belongs_to :section
  belongs_to :organization_user
  belongs_to :assignee, foreign_key: :assignee_id, class_name: 'OrganizationUser', optional: true

  has_many :comments, as: :commentable
  has_many :folders
  has_many :deal_documents, as: :documentable
  has_many :documents, through: :deal_documents

  scope :diligence, -> {where(section_id: DiligenceCategory.includes(:sections).map(&:sections).flatten.map(&:id))}
  scope :closing, -> {where(section_id: ClosingCategory.includes(:sections).map(&:sections).flatten.map(&:id))}
  scope :complete, -> {where(status: "Complete")}
  scope :incomplete, -> {where(status: "Incomplete")}


  before_validation :set_deal
  after_save :create_event_if_complete 

  def set_deal
    self.deal_id ||= self.section.deal_id
  end

  def create_event_if_complete
    if self.status_was != self.status and self.status == "Complete"
      Event.create(deal_id: self.deal_id, action: "TASK_COMPLETED", eventable: self)
    end
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
      due_date:     self.due_date,
      folders:      self.folders.map(&:to_hash),
      documents:    self.documents.distinct.map(&:to_hash)
    }

    if self.organization_user
      data[:organization_user] = self.organization_user
    end

    if self.assignee
      data[:assignee] = self.assignee.user.to_hash(false)
    end

    return data
  end
end
