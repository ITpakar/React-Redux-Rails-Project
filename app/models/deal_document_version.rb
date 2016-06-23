class DealDocumentVersion < ApplicationRecord
  include Traversable
  belongs_to :deal_document
  after_create :create_event

  def create_event
    Event.create(deal_id: self.deal_document.document.deal_id, action: "DOCUMENT_UPDATED", eventable: self)  
  end

  def to_hash
    data = {
      id:               self.id,
      name:             self.name,
      url:              self.url,
      download_url:     self.download_url,
      created_at:       self.created_at,
      changes: []
    }

    return data
  end
end
