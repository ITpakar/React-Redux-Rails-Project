class Document < ApplicationRecord
  include HasVisibility
  
  #Associations
  has_many :document_signers
  has_many :organization_users, through: :document_signers
  has_many :comments, as: :commentable
  has_many :deal_documents
  has_many :tasks,    through: :deal_documents, source: :documentable, source_type: 'Task'
  has_many :folders,  through: :deal_documents, source: :documentable, source_type: 'Folder'
  has_many :sections, through: :deal_documents, source: :documentable, source_type: 'Section'



  belongs_to :creator, foreign_key: :created_by, class_name: 'OrganizationUser'
  
  belongs_to :deal

  after_create :set_deal

  def to_hash
    data = {
      document_id:      self.id,
      title:            self.title,
      file_name:        self.file_name,
      file_size:        self.file_size,
      file_type:        self.file_type,
      file_uploaded_at: self.file_uploaded_at,
      activated:        self.activated
    }

    if self.creator
      data[:creator] = self.creator.to_hash(false)
    end

    return data
  end
end
