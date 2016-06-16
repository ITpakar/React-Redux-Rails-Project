require 'open-uri'

# Without this, it sets the local path to local.path and
# the multipart upload fails
class Pathname
  def path
    self.to_s
  end
end

class DealDocument < ApplicationRecord
  include Traversable
  belongs_to :document
  belongs_to :documentable, polymorphic: true
  belongs_to :deal

  has_many :comments, as: :commentable
  has_many :versions, class_name: 'DealDocumentVersion'
  has_many :document_signers

  before_validation :set_deal, on: :create
  after_create :set_deal

  def set_deal
    self.deal_id ||= self.traverse_up_to(Deal).try(:id)
  end

  # Note that this will always be executed asynchronously so it doesn't block
  def send_to_docusign
    # First we need to download the file from Box, we'll store it in /tmp
    url = self.download_url
    file_name = /([^\/]+?)$/.match(url).captures.try(:[], 0)

    file_path = Rails.root.join('tmp', "#{file_name}");
    open(file_path, 'wb') do |file|
      file << open(url).read
    end

    # Now we create an envelope and send it to Docusign, who deals with sending emails for us
    signers = self.document_signers.map(&:to_hash)

    host = Rails.env.development? ? ENV['NGROK_URL'] : Rails.root

    callback_url = Rails.application.routes.url_helpers.app_docusign_webhook_url(host: host)
    puts callback_url

    client = DocusignRest::Client.new
    document_envelope_response = client.create_envelope_from_document(
      email: {
        subject: "You've been asked to sign #{self.document.title}",
        body: "Please sign using the DocuSign link below"
      },
      signers: signers,
      files: [
        {
          path: file_path,
          name: self.document.title
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


  end

  # handle_asynchronously :send_to_docusign

  def to_hash
    data = {
      id:                self.id,
      deal_id:           self.deal_id,
      document_id:       self.document_id,
      documentable_id:   self.documentable_id,
      documentable_type: self.documentable_type,
      url:               self.url,
      download_url:      self.download_url
    }

    data[:versions] = []
    self.versions.order('created_at ASC').each do |version|
      v_data = version.to_hash
      data[:versions] << v_data
      data[:url] = v_data[:url]
      data[:download_url] = v_data[:download_url]
    end

    return data
  end
end
