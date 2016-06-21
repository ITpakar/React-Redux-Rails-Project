require 'yaml'

class User < ActiveRecord::Base

  ROLES = ["Normal", "Super"]

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :confirmable
  )

  mount_uploader :avatar, AvatarUploader

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

  def is_organization_admin?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationAdminUser.where(
      user_id: self.id,
      organization_id: organization_id
    ).first
    return !organization_user.blank?
  end

  def is_organization_member?(organization_id)
    return true if self.is_super?

    organization_user = OrganizationUser.where(
      user_id: self.id,
      organization_id: organization_id
    ).first
    return !organization_user.blank?
  end

  def context
    if self.is_organization_admin? self.organization
      return self.organization
    end

    return self.organization_user
  end

  def is_org_deal_admin?(deal_id)
    return true if self.is_super?

    deal = Deal.find_by_id(deal_id)
    return (deal and (deal.organization_user.user.id == self.id or deal.organization_user.organization.creator.id == self.id))
  end

  def is_deal_admin? deal
    return true if self.is_super?
    return true if self.is_organization_admin? deal.organization_user.organization
    return true if deal.organization_user_id == self.organization_user.id

    return false
  end

  def is_deal_collaborator?(deal_id)
    return true if self.is_super? or self.is_org_deal_admin?(deal_id)

    deal = Deal.find_by_id(deal_id)

    deal_collaborator = DealCollaborator.where(
      organization_user_id: organization_user.id,
      deal_id: deal_id
    ).first
    return !deal_collaborator.blank?
  end

  def is_document_owner?(document_id)
    return true if self.is_super?
    document = Document.find_by_id(document_id)

    return (document and document.created_by == self.organization_user.id)
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
    self.role == "Super"
  end

  def is_normal?
    self.role == "Normal"
  end

  def name
    [first_name, last_name].join(' ')
  end


  def to_hash(add_organization = true)
    data = {
      id: self.id ? self.id : self.email,
      email: self.email,
      user_id: self.id ? self.id : self.email,
      name: self.name,
      first_name: self.first_name,
      last_name: self.last_name,
      phone: self.phone,
      address: self.address,
      company: self.company,
      activated: self.activated,
      role: self.role,
      avatar: self.avatar.url
    }

    if add_organization and self.organization
      data[:organization] = [
        {
          id: self.organization.id,
          name: self.organization.name
        }
      ]
      data[:organization_user_id] = self.organization_user.id
    end

    return data
  end

  def email_domain
    /@(.+)/.match(self.email).try(:[], 1)
  end

  def initials
    first_name[0] + last_name[0]
  end

  def name
    "#{first_name} #{last_name}"
  end

  # Get Enterprise Box Client
  def self.enterprise_box_client
    if Rails.env.development?
      private_key = ENV['JWT_PRIVATE_KEY']
    else
      private_key = OpenSSL::PKey::RSA.new(YAML.load(%Q(---\n"#{ENV['JWT_PRIVATE_KEY']}"\n)), ENV['JWT_PRIVATE_KEY_PASSWORD'])
    end
    # Get Box enterprise token
    token = Boxr::get_enterprise_token(private_key: private_key)
    access_token = token.access_token

    # Get Box enterprise client
    Boxr::Client.new(access_token)
  end

  # Get Box Client
  def box_client
    client = User.enterprise_box_client

    unless self.organization_user.box_user_id
      user = client.create_user(self.email, is_platform_access_only: true)
      self.organization_user.update(box_user_id: user[:id])
    end

    if Rails.env.development?
      private_key = ENV['JWT_PRIVATE_KEY']
    else
      private_key = YAML.load(%Q(---\n"#{ENV['JWT_PRIVATE_KEY']}"\n))
    end
    token = Boxr::get_user_token(self.organization_user.box_user_id.to_s, private_key: private_key, private_key_password: ENV['JWT_PRIVATE_KEY_PASSWORD'])
    access_token = token.access_token
    Boxr::Client.new(access_token)
  end

  private
  def unescape(s)
    YAML.load(%Q(---\n"#{s}"\n))
  end
end
