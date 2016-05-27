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
  belongs_to :organization
  has_many   :starred_deals, dependent: :delete_all
  has_many   :deal_collaborators, dependent: :delete_all
  has_many   :users, through: :deal_collaborators
  has_many   :sections, dependent: :delete_all
  has_many   :tasks, dependent: :delete_all
  has_many   :documents
  has_many   :comments
  belongs_to :creator, foreign_key: :admin_user_id, class_name: 'User'

  # Validations
  validates :title, :client_name, :deal_size, :status, :admin_user_id, :activated, presence: true
  validates :title, length: {maximum: 250}
  validates :transaction_type, inclusion: {in: TRANSACTION_TYPES, message: "must be #{TRANSACTION_TYPES[0...-1].join(', ')} or #{TRANSACTION_TYPES.last}"}
  validates :projected_close_date, presence: {message: "must be a valid date MM/DD/YYYY"}
  validates :status, inclusion: {in: STATUSES}
  validates :creator, presence: true
  validates :organization, presence: true

  # Scopes
  scope :behind_schedule, -> {where('projected_close_date < ?', Date.today)}
  scope :nearing_completion, -> {where('projected_close_date >= ? AND projected_close_date < ?', Date.today, Date.today + NEARING_COMPLETION_DAYS.days)}

  before_validation :set_default_status, unless: :status
  after_create :create_deal_collaborator

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

  def set_default_status
    self.status = "Unstarted" unless status
  end

  def create_deal_collaborator
    self.deal_collaborators.create(
      user_id: self.admin_user_id,
      added_by: self.admin_user_id
    )
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
    return StarredDeal.where(user_id: user.id, deal_id: self.id).present?
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
    if self.creator
      data[:admin] = self.creator.to_hash(false)
    end

    return data
  end
end
