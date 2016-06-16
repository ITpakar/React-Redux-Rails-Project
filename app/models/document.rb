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
      data[:creator] = self.creator.user.to_hash(false)
    end

    data[:deal_documents] = []
    self.deal_documents.each do |deal_document|
      dd_data = deal_document.to_hash
      data[:deal_documents] << dd_data
      data[:url] = dd_data[:url]
      data[:download_url] = dd_data[:download_url]
    end

    return data
  end

  def upload_to_box(file, user, version_name = '1.0')
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
      box_file = client.upload_file(local_path, parent)
      updated_file = client.create_shared_link_for_file(box_file, access: :open)
      deal_document.update(box_file_id: box_file.id, url: updated_file.shared_link.url, download_url: updated_file.shared_link.download_url)
      deal_document.versions.create(name: version_name, box_version_id: box_file.id, url: updated_file.shared_link.url, download_url: updated_file.shared_link.download_url)
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
      box_version = client.upload_new_version_of_file(local_path, box_file)
      updated_file = client.create_shared_link_for_file(box_version, access: :open)
      deal_document.versions.create(name: name, box_version_id: box_version.id, url: updated_file.shared_link.url, download_url: updated_file.shared_link.download_url)
    end
  end
end
