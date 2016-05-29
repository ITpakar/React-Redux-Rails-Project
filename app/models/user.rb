class User < ActiveRecord::Base

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable
  )

  # Validations
  validates(
    :email,
    presence: true
  )
  validates(
    :first_name,
    presence: true
  )
  validates(
    :last_name,
    presence: true
  )
  validates(
    :phone,
    allow_blank: true,
    length:{
      maximum: 15
    }
  )
  validates(
    :company,
    allow_blank: true,
    length:{
      maximum: 100
    }
  )
  validates(
    :role,
    presence: true,
    inclusion: {
      in: [USER_SUPER, USER_NORMAL],
      message: "%{value} is not a valid role"
    }
  )

  #Associations
  has_one  :organization_user, dependent: :destroy
  has_one  :organization,      through: :organization_user
  has_many :document_signers
  has_many :documents, through: :document_signers
  has_many :comments
  has_many :deal_collaborators
  has_many :deals, through: :deal_collaborators
  has_many :notifications
  has_many :starred_deals
  has_many :tasks, foreign_key: :created_by
  has_many :folders, foreign_key: :created_by
  has_many :sections, foreign_key: :created_by

  def active_for_authentication?
    super && self.activated
  end

  def inactive_message
    "Failed to login"
  end

  def create_organization
    Organization.create(
      name: self.company,
      phone: self.phone,
      address: self.address,
      created_by: self.id,
      activated: true
    )
  end

  def create_organization_user(organization_id)
    OrganizationUser.create(
      user_id: self.id,
      organization_id: organization_id,
      user_type: 'Admin'
    )
  end

  def is_organzation_admin?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationUser.where(
      user_id: self.id,
      organization_id: organization_id,
      user_type: ORG_USER_TYPE_ADMIN
    ).first
    return !organization_user.blank?
  end

  def is_organzation_member?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationUser.where(
      user_id: self.id,
      organization_id: organization_id
    ).first
    return !organization_user.blank?
  end

  def is_org_deal_admin?(deal_id)
    return true if self.is_super?

    deal = Deal.find_by_id(deal_id)
    return (deal and (deal.admin_user_id == self.id or deal.organization.creator.id == self.id))
  end

  def is_deal_admin? deal
    return true if self.is_super?
    return true if self.is_organzation_admin? deal.organization
    return true if deal.creator == self

    return false
  end

  def is_deal_collaborator?(deal_id)
    return true if self.is_super? or self.is_org_deal_admin?(deal_id)

    deal = Deal.find_by_id(deal_id)

    deal_collaborator = DealCollaborator.where(
      user_id: id,
      deal_id: deal_id
    ).first
    return !deal_collaborator.blank?
  end

  def is_document_owner?(document_id)
    return true if self.is_super?
    document = Document.find_by_id(document_id)

    return (document and document.created_by == self.id)
  end

  def is_comment_owner?(comment_id)
    return true if self.is_super?
    comment = Comment.find_by_id(comment_id)

    return (comment and comment.user_id == self.id)
  end

  def is_notification_reciever?(notification_id)
    return true if self.is_super?
    notification = Notification.find_by_id(notification_id)

    return (notification and notification.user_id == self.id)
  end

  def is_super?
    self.role == USER_SUPER
  end

  def to_hash(add_organization = true)
    data = {
      email: self.email,
      user_id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      phone: self.phone,
      address: self.address,
      company: self.company,
      activated: self.activated,
      role: self.role
    }

    if add_organization and self.organization
      data[:organization] = [
        {
          id: self.organization.id,
          name: self.organization.name
        }
      ]
    end

    return data
  end

  def email_domain
    /@(.+)$/.match(email).captures.first
  end

  def displayed_deals
    if is_super?
      return Deal.all.includes(:users)
    elsif is_organzation_admin?(organization.try(:id))
      return organization.deals.includes(:users)
    else
      return deals.includes(:users)
    end
  end

  def deal_stats
    deals_for_stats = displayed_deals
    
    active_deals = deals_for_stats.where(status: Deal::ACTIVE_STATUSES)
    archived_deals = deals_for_stats.where(status: Deal::ARCHIVED_STATUSES)
    team_members = deals_for_stats.map(&:users).flatten.uniq
    outside_collaborators = team_members.select{|team_member| team_member.email.include? organization.email_domain}

    return {
      active_deals: active_deals.count,
      archived_deals: archived_deals.count,
      team_members: team_members.count, 
      outside_collaborators: outside_collaborators.count
    }
  end

  def recently_updated_files
    deals_for_files = displayed_deals

    ids = deals_for_files.map(&:id)

    folders = Folder.where(deal_id: ids).order('updated_at').last(5)
    documents = Document.where(deal_id: ids).order('updated_at').last(5)

    (documents + folders).sort_by{|e| e.updated_at}.last(5).reverse
  end

  def initials
    first_name[0] + last_name[0]
  end
end
