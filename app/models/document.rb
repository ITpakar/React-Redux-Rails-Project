class Document < ActiveRecord::Base
  #Associations
  has_many :document_signers
  has_many :users, through: :document_signers
  has_many :comments
end
