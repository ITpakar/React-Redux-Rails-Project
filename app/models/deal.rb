class Deal < ActiveRecord::Base

  # Magic constants
  STATUSES = ["Unstarted", "Pending", "Ongoing", "Completed", "Archived", "Closed"]
  ACTIVE_STATUSES = ["Unstarted", "Pending", "Ongoing", "Completed"]
  ARCHIVED_STATUSES = ["Archived"]
  CLOSED_STATUSES = ["Closed"]
  TRANSACTION_TYPES = ["M&A", "Venture Capital", "Commercial Lending", "Other"]
  # A deal is considered nearing completion if it's projected
  # close date is within this many days
  NEARING_COMPLETION_DAYS = 30

  # Associations
  belongs_to :organization_user
  belongs_to :organization
  has_many   :starred_deals, dependent: :delete_all
  has_many   :deal_collaborators, dependent: :delete_all
  has_many   :organization_users, through: :deal_collaborators
  has_many   :collaborators, through: :organization_users, source: :user
  has_many   :categories
  has_many   :deal_documents
  has_many   :documents, through: :deal_documents
  has_many   :sections, through: :categories
  has_many   :tasks, through: :sections
  has_many   :comments
  has_many   :events
  has_many   :starred_by, through: :starred_deals, source: :user
  has_many   :deal_collaborator_invites, dependent: :delete_all

  # Validations
  validates :title, :client_name, :deal_size, :status, :projected_close_date, :activated, presence: true
  validates :title, length: {maximum: 250}
  # The reason we allow nil is to show the message "is blank" if it's nil, not the not numerical message
  # Nil checks still happen with the first validation
  validates :deal_size, numericality: {message: "must be a valid number (10000 not $10000 or $10,000)", allow_nil: true}
  validates :transaction_type, inclusion: {in: TRANSACTION_TYPES, message: "must be #{TRANSACTION_TYPES[0...-1].join(', ')} or #{TRANSACTION_TYPES.last}"}
  # We allow_nil here for the same reason is the deal_size validation
  validates :projected_close_date, presence: {message: "must be a valid date MM/DD/YYYY", allow_nil: true}
  validates :status, inclusion: {in: STATUSES}

  # Scopes
  scope :behind_schedule, -> {where('projected_close_date < ?', Date.today).uniq}
  scope :nearing_completion, -> {where('projected_close_date >= ? AND projected_close_date < ?', Date.today, Date.today + NEARING_COMPLETION_DAYS.days).uniq}
  scope :active, -> {where(status: ACTIVE_STATUSES).uniq}
  scope :complete, -> {where(status: ARCHIVED_STATUSES + CLOSED_STATUSES).uniq}

  before_validation :set_default_status, :set_organization_id
  after_save :create_notification_if_closed
  after_create :create_deal_collaborator, :create_categories

  def set_default_status
    self.status = "Unstarted" unless status
  end

  def set_organization_id
    self.organization_id = self.organization_user.organization_id unless organization_id
  end

  def create_notification_if_closed
    if self.status_was != self.status and self.status == "Closed"
      Event.create(deal_id: self.id, action: "DEAL_CLOSED", eventable: self)
    end
  end

  def create_deal_collaborator
    self.deal_collaborators.create(
      organization_user_id: self.organization_user_id,
      added_by: self.organization_user_id
    )
  end

  def create_categories
    DiligenceCategory.create(activated: true, deal_id: self.id)
    ClosingCategory.create(activated: true, deal_id: self.id)
  end

  def add_collaborator! organization_user, added_by
    DealCollaborator.create(deal_id: self.id, organization_user: organization_user, added_by: added_by.id)
  end

  def invite_collaborator collaborator_email, added_by
    if (self.collaborators.where(email: collaborator_email).empty? && self.deal_collaborator_invites.where(email: collaborator_email).empty?) 
      DealCollaboratorInvite.create(deal_id: self.id, email: collaborator_email, added_by: added_by.id)
    end
  end

  def clear_collaborators organization_user_ids
    DealCollaborator.where('deal_id = ? AND organization_user_id NOT IN (?)', self.id, organization_user_ids.select { |id| !id.include? '@' }).delete_all
    DealCollaboratorInvite.where('deal_id = ? AND email NOT IN (?)', self.id, organization_user_ids.select { |id| id.include? '@' }).delete_all
  end

  def diligence_category
    self.categories.where(name: 'DiligenceCategory').first
  end

  def closing_category
    self.categories.where(name: 'ClosingCategory').first
  end

  def completion_percent
    all_tasks = self.tasks
    return 0 unless all_tasks.present?
    completed_tasks = all_tasks.complete

    100 * (completed_tasks.count.to_f/all_tasks.count.to_f)
  end

  def diligence_completion_percent
    diligence_tasks = self.tasks.diligence
    return 0 unless diligence_tasks.present?

    (diligence_tasks.complete.count * 100) / diligence_tasks.count
  end

 def closing_completion_percent
    closing_tasks = self.tasks.closing
    return 0 unless closing_tasks.present?

    (closing_tasks.complete.count * 100) / closing_tasks.count
  end

  def recently_updated_files
    documents = Document.where(deal_id: id).order('updated_at').last(5)
    folders = Folder.where(deal_id: id).order('updated_at').last(5)

    (documents + folders).sort_by {|e| e.updated_at}.last(5).reverse
  end

  # Will return date like so
  # December 2015
  def friendly_date
    projected_close_date.strftime("%B %Y")
  end

  def starred_by? user
    return StarredDeal.where(organization_user_id: user.organization_user.id, deal_id: self.id).present?
  end

  def close!
    self.status = "Closed"
    self.save
  end

  def to_hash
    data = {
      deal_id:              self.id,
      title:                self.title,
      client_name:          self.client_name,
      transaction_type:     self.transaction_type,
      deal_size:            self.deal_size,
      projected_close_date: self.projected_close_date,
      status:               self.status,
      activated:            self.activated
    }
    if self.organization_user
      data[:admin] = self.organization_user.user.to_hash(false)
    end

    return data
  end
end
