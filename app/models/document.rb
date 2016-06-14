class Document < ApplicationRecord
  include HasVisibility

  #Associations
  has_many :document_signers
  has_many :organization_users, through: :document_signers
  has_many :deal_documents
  has_many :tasks,    through: :deal_documents, source: :documentable, source_type: 'Task'
  has_many :folders,  through: :deal_documents, source: :documentable, source_type: 'Folder'
  has_many :sections, through: :deal_documents, source: :documentable, source_type: 'Section'

  accepts_nested_attributes_for :deal_documents

  FILE_TYPES = ["Doc", "Pdf", "Txt"]

  belongs_to :creator, foreign_key: :created_by, class_name: 'OrganizationUser'

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

  def upload_to_box(file, user)
    tmp = "#{Rails.root}/tmp/"
    client = user.box_client
    self.deal_documents.each do |deal_document|
      folders = []
      folders << deal_document.documentable.deal.organization.name
      folders << deal_document.documentable.deal.title
      folders << deal_document.documentable.section.name
      folders << deal_document.documentable.title if deal_document.documentable_type == 'Task'
      path = '/'
      parent = client.folder_from_path(path)
      folders.each do |folder|
        box_folder = client.folder_items(parent).folders.select{|i| i.name == folder}.first
        if box_folder.nil?
          box_folder = client.create_folder(folder, parent)
        end
        parent = box_folder
      end
      local_path = "#{tmp}#{deal_document.id}#{File.extname(file.original_filename)}"
      File.open(local_path, "wb") { |f| f.write(file.read) }
      file = client.upload_file(local_path, parent)
      deal_document.update(box_file_id: file.id)
    end
  end

  def add_new_version(file, name)
    tmp = "#{Rails.root}/tmp/"
    client = user.box_client
    self.deal_documents.each do |deal_document|
      next unless deal_document.box_file_id
      box_file = client.file_from_id(deal_document.box_file_id)
      local_path = "#{tmp}#{deal_document.id}#{File.extname(file.original_filename)}"
      File.open(local_path, "wb") { |f| f.write(file.read) }
      box_file = client.upload_new_version_of_file(local_path, box_file)
      deal_document.versions.create(name: name, box_version_id: box_file.id)
    end
  end
end
