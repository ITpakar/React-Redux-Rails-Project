require 'open-uri'

# Without this, it sets the local path to local.path and
# the multipart upload fails
class Pathname
  def path
    self.to_s
  end
end

class Document < ApplicationRecord
  include HasVisibility
  include BoxFileStoragable

  #Associations
  has_many :document_signers
  has_many :organization_users, through: :document_signers
  has_many :deal_documents
  has_many :tasks,    through: :deal_documents, source: :documentable, source_type: 'Task'
  has_many :folders,  through: :deal_documents, source: :documentable, source_type: 'Folder'
  has_many :sections, through: :deal_documents, source: :documentable, source_type: 'Section'
  has_many :closing_book_documents

  accepts_nested_attributes_for :deal_documents

  FILE_TYPES = ["Doc", "Pdf", "Txt"]

  belongs_to :creator, foreign_key: :created_by, class_name: 'OrganizationUser'
  belongs_to :deal

  def to_hash
    data = {
      document_id:      self.id,
      deal_id:          self.deal_id,
      title:            self.title,
      file_name:        self.file_name,
      file_size:        self.file_size,
      file_type:        self.file_type,
      file_uploaded_at: self.file_uploaded_at,
      activated:        self.activated,
      signed_count:     self.document_signers.where(signed: true).count,
      signers_count:    self.document_signers.count,
      signers:          self.document_signers.map(&:to_hash)
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

  def create_signers! signers
    signers.each do |signer|
      self.document_signers.create!(signer) unless signer["name"].blank? or signer["email"].blank?
    end
  end

  # Note that this will always be executed asynchronously so it doesn't block
  def send_to_docusign
    # First we need to download the file from Box, we'll store it in /tmp
    puts "Downloading file"
    url = self.deal_documents.first.versions.last.download_url
    file_name = /([^\/]+?)$/.match(url).captures.try(:[], 0)

    file_path = Rails.root.join('tmp', "#{file_name}");
    open(file_path, 'wb') do |file|
      file << open(url).read
    end

    # Now we create an envelope and send it to Docusign, who deals with sending emails for us
    puts "Sending request to DocuSign"
    signers = self.document_signers.map(&:to_hash)

    host = Rails.env.development? ? ENV['NGROK_URL'] : Rails.application.routes.default_url_options[:host] || ActionMailer::Base.default_url_options[:host]

    callback_url = Rails.application.routes.url_helpers.app_docusign_webhook_url(host: host)

    client = DocusignRest::Client.new
    document_envelope_response = client.create_envelope_from_document(
      email: {
        subject: "You've been asked to sign #{self.title}",
        body: "Please sign using the DocuSign link above"
      },
      signers: signers,
      files: [
        {
          path: file_path,
          name: self.title
        }
      ],
      status: 'sent',
      eventNotification: {
        url: callback_url,
        loggingEnabled: true,
        recipientEvents: ['Completed', 'Declined', 'AuthenticationFailed', 'AutoResponded']
      }
    )

    envelope_id = document_envelope_response["envelopeId"]
    self.document_signers.update_all(envelope_id: envelope_id)

    # Lastly we delete the saved document
    puts "Deleting file"
    File.delete(file_path) if File.exist?(file_path)
  end

  handle_asynchronously(:send_to_docusign) unless Rails.env.test?

  def upload_file(file, organization_user)
    tmp = "#{Rails.root}/tmp/"

    self.deal_documents.each do |deal_document|
      version = deal_document.upcoming_version
      folders = []
      folders << deal_document.documentable.deal.organization.name
      folders << deal_document.documentable.deal.title
      folders << deal_document.documentable.section.name
      folders << deal_document.documentable.title if deal_document.documentable_type == 'Task'
      folders << 'Document ' + deal_document.id.to_s

      filename = file.original_filename
      extname = File.extname(filename)
      local_path = "#{tmp}#{File.basename(filename, extname)} - #{version}#{extname}"
      File.open(local_path, "wb") { |f| f.write(file.read) }
      box_file = upload_to_box(local_path, folders, organization_user)
      deal_document.versions.create(name: version, box_file_id: box_file[:id], url: box_file[:url], download_url: box_file[:download_url])
    end
  end
end
