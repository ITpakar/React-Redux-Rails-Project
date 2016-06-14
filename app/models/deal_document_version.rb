class DealDocumentVersion < ApplicationRecord
  include Traversable
  belongs_to :deal_document
  belongs_to :document, through: :deal_document

  def to_hash(box_client = nil)
    data = {
      id:      self.id,
      name:    self.name,
      changes: []
    }

    if box_client.present? && self.deal_document.box_file_id.present? && self.box_version_id.present?
      box_file = client.file_from_id(self.deal_document.box_file_id)
      data[:url] = box_client.download_url(box_file, self.box_version_id)
    end

    return data
  end
end
