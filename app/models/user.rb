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

  #Associations
  has_one  :organization_user, dependent: :destroy
  has_one  :organization,      through: :organization_user
  has_many :document_signers
  has_many :documents, through: :document_signers
  has_many :comments
  has_many :deal_collaborators
  has_many :deals, through: :deal_collaborators
  has_many :notifications
  has_many :started_deals
  has_many :tasks
end
