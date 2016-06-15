class DealDocumentVersion < ApplicationRecord
  include Traversable
  belongs_to :deal_document

  def to_hash
    data = {
      id:      self.id,
      name:    self.name,
      url:     self.url,
      changes: []
    }

    return data
  end
end
